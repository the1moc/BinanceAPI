{-# LANGUAGE OverloadedStrings #-}

module Requests where

import           Control.Monad
import           Data.Aeson
import           Data.ByteString.Lazy      (ByteString)
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS   (tlsManagerSettings)
import           Network.HTTP.Types.Status (statusCode)
import           Types

pingRequest :: [String] -> IO (Maybe ServerResponse)
pingRequest _ = do
  manager <- newManager tlsManagerSettings
  request <- parseRequest $ apiBase ++ "ping"
  response <- httpLbs request manager
  return . decode $ responseBody response

timeRequest :: [String] -> IO (Maybe ServerResponse)
timeRequest _ = do
  manager <- newManager tlsManagerSettings
  request <- parseRequest $ apiBase ++ "time"
  response <- httpLbs request manager
  return . decode $ responseBody response
