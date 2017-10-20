{-# LANGUAGE NamedFieldPuns    #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Applicative
import           Control.Exception
import           Control.Monad.IO.Class
import           Control.Monad.Trans
import           Data.Aeson
import           Data.ByteString.Lazy      (ByteString)
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS   (tlsManagerSettings)
import           Network.HTTP.Types.Status (statusCode)
import           System.Environment
import           System.Exit               (ExitCode (ExitFailure), exitWith)
import           Types

endpointLookupTable :: [(String, [String] -> IO (Response ByteString))]
endpointLookupTable = [("ping", pingRequest),
                       ("time", timeRequest)]

exitFailure :: IO ()
exitFailure = do
  putStrLn "No arguments given"
  exitWith $ ExitFailure 1

main :: IO ()
main = do
  args <- getArgs
  if null args
  then exitFailure
  else case lookup (head args) endpointLookupTable of
        (Just f) -> do
          response <- f $ tail args
          print $ responseBody response
        Nothing -> putStrLn "Invalid args"

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
