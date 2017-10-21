{-# LANGUAGE NamedFieldPuns    #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Applicative
import           Control.Exception
import           Control.Monad.IO.Class
import           Control.Monad.Trans
import           Data.Aeson
import           Data.ByteString.Lazy   (ByteString)
import           Data.Char              (toLower)
import           Data.Maybe
import           Network.HTTP.Client
import           Requests
import           System.Environment
import           System.Exit            (ExitCode (ExitFailure), exitWith)
import           Types

endpointLookupTable :: [(String, [String] -> IO (Maybe ServerResponse))]
endpointLookupTable = [("get", processGet)]
                      --  ("post", processPost)]

exitFailure :: IO ()
exitFailure = do
  putStrLn "No arguments given"
  exitWith $ ExitFailure 1

main :: IO ()
main = do
  args <- getArgs
  if null args
  then exitFailure
  else case lookup (map toLower $ head args) endpointLookupTable of
        (Just f) -> f (tail args) >>= print
        Nothing -> putStrLn "Please specify either a get or post request"
