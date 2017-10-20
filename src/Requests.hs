{-# LANGUAGE OverloadedStrings #-}

module Requests where

import           Control.Monad
import           Data.Aeson
import           Data.ByteString.Lazy      (ByteString)
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS   (tlsManagerSettings)
import           Network.HTTP.Types.Status (statusCode)
import           Types

pingRequest :: [String] -> IO (Response ByteString)
pingRequest _ = do
  manager <- newManager tlsManagerSettings
  request <- parseRequest $ apiBase ++ "ping"
  httpLbs request manager

timeRequest :: [String] -> IO (Response ByteString)
timeRequest _ = do
  manager <- newManager tlsManagerSettings
  request <- parseRequest $ apiBase ++ "time"
  httpLbs request manager
