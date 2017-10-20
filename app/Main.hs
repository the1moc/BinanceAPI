{-# LANGUAGE NamedFieldPuns    #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Applicative
import           Control.Exception
import           Control.Monad.IO.Class
import           Control.Monad.Trans
import           Data.Aeson
import           Data.ByteString.Lazy   (ByteString)
import           Network.HTTP.Client
import           Requests
import           System.Environment
import           System.Exit            (ExitCode (ExitFailure), exitWith)
import           Types

endpointLookupTable :: [(String, [String] -> IO (Maybe ServerResponse))]
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
          print response
        Nothing -> putStrLn "Invalid args"
