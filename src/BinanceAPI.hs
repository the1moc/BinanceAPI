{-# LANGUAGE OverloadedStrings #-}

module BinanceAPI (makePostRequest, makeGetRequest) where

import           BinanceAPI.Requests (processGet, processPost)
import           BinanceAPI.Types    (ServerResponse (..))
import           Data.Maybe          (fromJust, isJust)
import           System.Environment  (getArgs)

makePostRequest :: [String] -> IO (Maybe ServerResponse)
makePostRequest = processPost

makeGetRequest :: [String] -> IO (Maybe ServerResponse)
makeGetRequest = processGet

main :: IO ()
main = do
  args <- getArgs
  if null args
  then error "Please provide some arguments"
  else do
    getResult <- makeGetRequest args
    --postResult <- makePostRequest args
    maybe (print "No valid response") print getResult
