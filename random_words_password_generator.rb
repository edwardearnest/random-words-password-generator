#!/usr/bin/env ruby
# random_words_password_generator.rb
#
# Created: 2013-09-05
# Revised: 2013-09-07
#
# Copyright 2013 by Edward Earnest. 
# Licensed under GNU GPLv3. Please see file LICENSE.
#
# SUMMARY: 
#
#  This program gives you a password consisting of five random
#  period-delimited words in the form: 
#
#      word1.word2.word3.word4.word5
#
# GETTING STARTED & SYSTEM REQUIREMENTS:
# 
#  Any *nix-like system with a wordlist living in /usr/share/dict/words
#  Windows users may substitue a wordlist of their choice.
#  Open an issue on GitHub if you need help with this. 
#
#  1. Install Ruby (https://www.ruby-lang.org/) & ensure a word list is present.
#         Debian/Ubuntu: 
#         $ sudo apt-get install ruby wordlist
#  
#     Written for Ruby 2.0, but should work for 1.9 branch and maybe 1.8 branch.
# 
#  2. Run this file.
#         $ ruby random_words_password_generator.rb
# 
# NOTES:
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
#       this is Good Enough for me & I'll trust that OpenSSL and the
#       Ruby Core Team know more about this than I do.
#
#  3. Because these are words and "not very entropy-dense", you
#     need to be careful about leaking enough of your password that
#     someone could guess the rest.  For example, you don't want 
#     someone to see you typing it in and deduce that you are typing:
#
#         fiv?.w???s.as.y??r.pa??word 
#
# ACKNOWLEDGMENTS:
#
#   Randall Munroe of xkcd.com, for the original comic and the insight
#       that reasonable human-memorizable passwords are stronger than 
#       more computer-oriented passwords that you keep on a sticky note 
#       on your computer monitor.
#
#   Colin Percival, for his input on the cryptographic integrity of
#       this method. If you like this, check out Tarsnap [3] - secure
#       online backups.
#
# While both the pattern of the overall string & the fact that we are
# using words are both known, so long as the words are truly random
# and not chosen because they hold meaning for the end user, we should
# be fine. 
# 
# TL;DR - let the machine pick & accept what it picks. 
#
# REFERENCES:
# 
#   [1] https://xkcd.com/936/
#   [2] Disclaimer: I am not cryptography or information theory
#         expert. This is a hobby program I created on my own time that
#         should be sufficient to increase my own password security
#         enough for the moment.  I would sleep better if this used
#         /dev/random, but in a choice between more research into the
#         random mechanics of OpenSSL vs. /dev/(u)random and getting
#         this finished and getting sleep, I choose the latter.
#   [3] Tarsnap is secure backups for Unix geeks:
#           <https://www.tarsnap.com/>
#           "Online backups for the truly paranoid." 
#       Personally, I use cron & Tarsnap-generations to manage my 
#       Tarsnap backups: <https://github.com/Gestas/Tarsnap-generations>
#
###
# TODO
# I've tested these, but having unit tests to prove them would be great:
# -- filtering of apostrophies
# -- filtering of anything capitalized
# -- newline removal
# -- final password is of the form <word>.<word>.<word>.<word> 
# -- final password, as above, has no trailing dot
###
require 'securerandom'

puts "Reading wordlist..."
list_of_words = IO.readlines('/usr/share/dict/words')

# Remove any proper nouns (anything with initial capitalization) and
# also any words with apostrophies.
puts "Processing wordlist..."
list_of_words = list_of_words.delete_if {|word| word.include?("\'")}
list_of_words = list_of_words.delete_if {|word| word[0].match("[A-Z]")}

# Remove newlines
list_of_words = list_of_words.map { |word| word.chomp }
max_words = list_of_words.length

puts "We are working with #{max_words} words!"
puts ""

# While arrays are zero-indexed in Ruby, we don't need to adjust for
# this when determining max_words because SecureRandom.random_number
# will return a number < max_words
password = ''
puts "Generating password (this could take a little while)..."

5.times do
  array_index = SecureRandom.random_number(max_words)
  word = list_of_words[array_index]
  password << word << '.'
end

# Remove the final period.
password.chomp!(".") 

# TODO - citation needed - will changing the order reduce entropy?
puts ""
puts "Your new password has been generated; if you don't like it, you
may change the order, but that will reduce the ethropy slightly."
puts "" # formatting
puts "   Your new password is: #{password}"
puts "" # formatting
puts "Keep it safe." 
