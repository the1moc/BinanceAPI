{-# LANGUAGE OverloadedStrings #-}

module Requests where

import           Data.Aeson
import qualified Data.ByteString.Char8      as QBString (ByteString, pack)
import qualified Data.ByteString.Lazy.Char8 as LBString (ByteString, pack,
                                                         unpack)
import           Data.Maybe
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS    (tlsManagerSettings)
import qualified Network.HTTP.QueryString   as QString
import           Network.HTTP.Types         (renderQuery)
import           Network.HTTP.Types.Status  (statusCode)
import           Types
import           Util

-- Constants
apiBase = "https://www.binance.com/api/v1/"

createConnectionManager :: IO Manager
createConnectionManager = newManager tlsManagerSettings

querystringLookupTable :: [(String, [QBString.ByteString])]
querystringLookupTable = [("depth", ["symbol", "limit"])]

createRawData :: [String] -> [QBString.ByteString]
createRawData xs = let maybeParams = lookup (head xs) querystringLookupTable
                   in case maybeParams of
                     (Just params) -> params
                     _ -> error $ "Cannot find a GET request instance for keyword: " ++ head xs

generateQueryString :: [String] -> QBString.ByteString
generateQueryString xs = QString.toString qs
                      where
                        createByteStringPairs = zip (createRawData xs) (QBString.pack <$> tail xs)
                        qs = QString.queryString createByteStringPairs

createGetRequest :: [String] -> IO Request
createGetRequest args
  | null args = error "Need to give at least the endpoint desired"
  | length args == 1 = parseRequest $ apiBase ++ head args
  | otherwise = do
       initialRequest <- parseRequest $ apiBase ++ head args
       let formedRequest = initialRequest {
                                            queryString = generateQueryString args
                                          }
       return formedRequest

processGet :: [String] -> IO (Maybe ServerResponse)
processGet s = do
  manager <- createConnectionManager
  request <- createGetRequest s
  response <- httpLbs request manager
  return . decode $ removeEmptyListFromResponse $ responseBody response
