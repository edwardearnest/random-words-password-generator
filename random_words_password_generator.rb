# random_words_password_generator.rb
#
# Created: 2013-09-05
# Revised: 2013-09-05
#
# Copyright 2013 by Edward Earnest. 
# Licensed under GNU GPLv3. Please see file LICENSE.
# 
# Gives you a password consisting of five random period-delimited
# words in the form: 
#      word1.word2.word3.word4.word5
#
# I call this the XKCD-method [1], which should [2] be cryptographically
# secure so long as:
#
#  1. You accept the words that it picks (if you don't, they won't be
#     random, which -- as I understand it -- will skew things).
#
#  2. The source of your randomness is sufficiently random. 
#
#       Note: SecureRandom appears to fall back to /dev/urandom on
#       *nix-type systems if OpenSSL isn't available; it might be
#       worth looking into a /dev/random solution, but for the moment
#       this is Good Enough for me.
#
#  3. Because these are words and "not very entropy-dense", you
#     need to be careful about leaking enough of your password that
#     someone could guess the rest.  You don't want someone to see
#     you typing it in and deduce that you are typing in
#       fiv?.w???s.as.y??r.pa??word 
#
# Acknowledgments:
#   Randall Munroe, for the original comic and the insight that
#       reasonable human-memorizable passwords are stronger than more
#       computer-oriented passwords that you keep on a sticky note on
#       your computer monitor.
#                                        cryptographic
#   Colin Percival, for his input on the cryptographic integrity of
#       this method. If you like this, check out Tarsnap [3] - secure online
#       backups.
#
# While both the pattern of the overall string & the fact that we are
# using words are both known, so long as the words are truly random
# and not chosen because they hold meaning for the end user, we should
# be fine.
#
# TL;DR - let the machine pick & accept what it picks. 
#
# Bonus - your vocabulary improves!
#
# [1] https://xkcd.com/936/
# [2] Disclaimer: I am not cryptography or information theory
#       expert. This is a hobby program I created on my own time that
#       should be sufficient to increase my own password security
#       enough for the moment.  I would sleep better if this used
#       /dev/random, but in a choice between more research into the
#       random mechanics of OpenSSL vs. /dev/(u)random and getting
#       this finished and getting sleep, I choose the latter.
# [3] Tarsnap is secure backups for Unix geeks:
#      <https://www.tarsnap.com/>
#       "Online backups for the truly paranoid." 
#     I use cron & Tarsnap-generations to manage my Tarsnap backups.
#      <https://github.com/Gestas/Tarsnap-generations>
#
require 'securerandom'
array_of_dictionary_words = IO.readlines('/usr/share/dict/words')
max_words = array_of_dictionary_words.length

# TODO - filter out words with apostorphie's.
# TODO MAYBE - filter out Proper Names? (anything with initial uppercase?)

"We are working with #{max_words} words!"

# While arrays are zero-indexed in Ruby, we don't need to adjust for
# this when determining max_words because SecureRandom.random_number
# will return a number < max_words
password = ''
5.times do |number|
  puts "Generating word number #{number + 1}..."
  array_index = SecureRandom.random_number(max_words)
  word = array_of_dictionary_words[array_index]
  password << word << '.' # TODO Fix so all on one line; or is that a
                          # feature not a bug?
end

# TODO - citation needed - will changing the order reduce entropy?
puts "Your new password has been generated; if you don't like it, you
may change the order, but that will reduce the ethropy slightly.
[citation needed]" 
puts "" # formatting
puts "Your password is: #{password}"
puts "Keep it safe." 
