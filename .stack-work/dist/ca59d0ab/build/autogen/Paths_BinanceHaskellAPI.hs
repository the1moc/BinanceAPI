{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_BinanceHaskellAPI (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Malcolm\\Documents\\BinanceHaskellAPI\\BinanceHaskellAPI\\.stack-work\\install\\d7a37d2f\\bin"
libdir     = "C:\\Users\\Malcolm\\Documents\\BinanceHaskellAPI\\BinanceHaskellAPI\\.stack-work\\install\\d7a37d2f\\lib\\x86_64-windows-ghc-8.0.2\\BinanceHaskellAPI-0.1.0.0-BCgZtDk5WcQ7EyRB2xSCSq"
dynlibdir  = "C:\\Users\\Malcolm\\Documents\\BinanceHaskellAPI\\BinanceHaskellAPI\\.stack-work\\install\\d7a37d2f\\lib\\x86_64-windows-ghc-8.0.2"
datadir    = "C:\\Users\\Malcolm\\Documents\\BinanceHaskellAPI\\BinanceHaskellAPI\\.stack-work\\install\\d7a37d2f\\share\\x86_64-windows-ghc-8.0.2\\BinanceHaskellAPI-0.1.0.0"
libexecdir = "C:\\Users\\Malcolm\\Documents\\BinanceHaskellAPI\\BinanceHaskellAPI\\.stack-work\\install\\d7a37d2f\\libexec"
sysconfdir = "C:\\Users\\Malcolm\\Documents\\BinanceHaskellAPI\\BinanceHaskellAPI\\.stack-work\\install\\d7a37d2f\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "BinanceHaskellAPI_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "BinanceHaskellAPI_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "BinanceHaskellAPI_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "BinanceHaskellAPI_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "BinanceHaskellAPI_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "BinanceHaskellAPI_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
