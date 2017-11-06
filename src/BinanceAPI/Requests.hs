{-# LANGUAGE OverloadedStrings #-}

module BinanceAPI.Requests (processGet, processPost) where

import           BinanceAPI.Types
import           BinanceAPI.Utilities       (removeEmptyListFromResponse)
import           Data.Aeson                 (decode, encode)
import qualified Data.ByteString.Char8      as QBString (ByteString, pack)
import qualified Data.ByteString.Lazy.Char8 as LBString (ByteString, pack,
                                                         unpack)
import           Data.Monoid
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS    (tlsManagerSettings)
import qualified Network.HTTP.QueryString   as QString (queryString, toString)
import           Network.HTTP.Types         (renderQuery)

-- Constants
apiBase = "https://www.binance.com/api/v1/"

-- Connection manager
createConnectionManager :: IO Manager
createConnectionManager = newManager tlsManagerSettings

-- Requests and their params
requestParamLookupTable :: [(String, [QBString.ByteString])]
requestParamLookupTable = [("depth", ["symbol", "limit"])
                          ,("aggTrades", ["symbol", "fromId", "startTime", "endTime", "limit"])
                          , ("klines", ["symbol", "interval", "limit", "startTime", "endTime"])
                          , ("ticker/24hr", ["symbol"])]


getRequestParams :: String -> [QBString.ByteString]
getRequestParams requestName = let maybeParams = lookup requestName requestParamLookupTable
                   in case maybeParams of
                     (Just params) -> params
                     _ -> error $ "Cannot find a GET request instance for keyword: " ++ requestName

-- GET Request processing
generateQueryString :: [String] -> QBString.ByteString
generateQueryString xs = QString.toString qs
                      where
                        createByteStringPairs = zip (getRequestParams $ head xs) (QBString.pack <$> tail xs)
                        qs = QString.queryString createByteStringPairs

generateInitialRequest :: String -> IO Request
generateInitialRequest endpointName = parseRequest $ apiBase <> endpointName

createGetRequest :: [String] -> IO Request
createGetRequest args
  | null args = error "Need to give at least the endpoint desired"
  | otherwise = do
       req <- generateInitialRequest $ head args
       if length args == 1 then return req
       else return req
            {
                queryString = generateQueryString args
            }


processGet :: [String] -> IO (Maybe ServerResponse)
processGet s = do
  manager <- createConnectionManager
  request <- createGetRequest s
  response <- httpLbs request manager
  return . decode $ removeEmptyListFromResponse $ responseBody response

-- Post requesting processing
processPost :: [String] -> IO (Maybe ServerResponse)
processPost = undefined
