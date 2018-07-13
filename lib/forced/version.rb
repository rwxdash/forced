module Forced
  MAJOR = 0
  MINOR = 1
  TINY  = 0
  PRE   = nil

  VERSION = [MAJOR, MINOR, TINY, PRE].compact.join('.').freeze
end
