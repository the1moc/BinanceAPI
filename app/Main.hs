{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE NamedFieldPuns    #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Applicative
import           Control.Monad.IO.Class
import           Control.Monad.Trans
import           Data.Aeson
import           Data.Attoparsec.Number
import           Data.ByteString.Lazy
import           Network.HTTP.Conduit

data Time = Time {
  serverTime :: Number
  } deriving Show

instance FromJSON Time where
  parseJSON (Object t) = Time
                         <$> t .: "serverTime"

main :: IO ()
main = do
  time >>= print

time :: (MonadIO m) => m (Maybe Time)
time = get "time" >>= return . decode

get :: MonadIO m => String -> m ByteString
get time = simpleHttp $ "https://www.binance.com/api/v1/" ++ time
