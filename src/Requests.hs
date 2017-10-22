{-# LANGUAGE OverloadedStrings #-}

module Requests (processGet, processPost) where

import           Data.Aeson                 (decode)
import qualified Data.ByteString.Char8      as QBString (ByteString, pack)
import qualified Data.ByteString.Lazy.Char8 as LBString (ByteString, pack,
                                                         unpack)
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS    (tlsManagerSettings)
import qualified Network.HTTP.QueryString   as QString (queryString, toString)
import           Network.HTTP.Types         (renderQuery)
import           Network.HTTP.Types.Status  (statusCode)
import           Types
import           Util                       (removeEmptyListFromResponse)

-- Constants
apiBase = "https://www.binance.com/api/v1/"

createConnectionManager :: IO Manager
createConnectionManager = newManager tlsManagerSettings

-- GET Requests
requestParamLookupTable :: [(String, [QBString.ByteString])]
requestParamLookupTable = [("depth", ["symbol", "limit"])]

getRequestParams :: String -> [QBString.ByteString]
getRequestParams requestName = let maybeParams = lookup requestName requestParamLookupTable
                   in case maybeParams of
                     (Just params) -> params
                     _ -> error $ "Cannot find a GET request instance for keyword: " ++ requestName

generateQueryString :: [String] -> QBString.ByteString
generateQueryString xs = QString.toString qs
                      where
                        createByteStringPairs = zip (getRequestParams $ head xs) (QBString.pack <$> tail xs)
                        qs = QString.queryString createByteStringPairs

createGetRequest :: [String] -> IO Request
createGetRequest args
  | null args = error "Need to give at least the endpoint desired"
  | length args == 1 = parseRequest $ apiBase ++ head args
  | otherwise = do
       initialRequest <- parseRequest $ apiBase ++ head args
       let formedRequest = initialRequest
                            {
                              queryString = generateQueryString args
                            }
       return formedRequest

processGet :: [String] -> IO (Maybe ServerResponse)
processGet s = do
  manager <- createConnectionManager
  request <- createGetRequest s
  response <- httpLbs request manager
  return . decode $ removeEmptyListFromResponse $ responseBody response

-- POST REQUESTS
processPost :: [String] -> IO (Maybe ServerResponse)
processPost = undefined
