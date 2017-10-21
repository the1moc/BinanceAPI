{-# LANGUAGE OverloadedStrings #-}

module Requests where

import           Control.Monad
import           Data.Aeson
import qualified Data.ByteString.Char8     as B
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS   (tlsManagerSettings)
import           Network.HTTP.Types        (renderQuery)
import           Network.HTTP.Types.Status (statusCode)
import           Types

createConnectionManager :: IO Manager
createConnectionManager = newManager tlsManagerSettings

-- This is awful but it will do FOR NOW#
-- seeing as it is only for like, one of the requests
createQueryString :: [String] -> String
createQueryString ["depth", symbol, limit] = "symbol=" ++ symbol ++ "&limit=" ++ limit
createQueryString ["depth", symbol] = "symbol=" ++ symbol ++ "&limit=100"

createGetRequest :: [String] -> IO Request
createGetRequest args
  | length args == noArg = error "Need to give at least the endpoint desired"
  | length args == singleArg = parseRequest $ apiBase ++ head args
  | otherwise = do
       initialRequest <- parseRequest $ apiBase ++ head args
       let formedRequest = initialRequest
                    {
                      queryString = B.pack $ createQueryString args
                    }
       return formedRequest

processGet :: [String] -> IO (Maybe ServerResponse)
processGet s = do
  manager <- createConnectionManager
  request <- createGetRequest s
  response <- httpLbs request manager
  print response
  return . decode $ responseBody response
