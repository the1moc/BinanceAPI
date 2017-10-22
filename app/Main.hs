{-# LANGUAGE NamedFieldPuns    #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.ByteString.Lazy (ByteString)
import           Data.Char            (toLower)
import           Network.HTTP.Client
import           Requests             (processGet, processPost)
import           System.Environment   (getArgs)
import           System.Exit          (ExitCode (ExitFailure), exitWith)
import           Types                (ServerResponse)

endpointLookupTable :: [(String, [String] -> IO (Maybe ServerResponse))]
endpointLookupTable = [("get", processGet), ("post", processPost)]

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
        (Just f) -> do
          result <- f (tail args)
          case result of
            Just r -> print r
            Nothing -> error "Request failed; check your parameters"
        Nothing -> error "Please specify either a get or post request"
