#!/usr/bin/env ruby
# coding: utf-8
#
# This is a learning task.
# Ruby is not very fast, but it is with objects ;)
#
# Implementation of suffix automaton
# Task: the longest common subsequence
# 
# Usage: cat data | lcs.rb 
#
# Sample data:
# 
# 3 
# abacaba
# mycabarchive
# acabistrue
#
# Line 1: rows 1<=k<=10
#
# Copyright (c) 2013 Lebedev Vadim abraham1901@gmail.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# https://github.com/abraham1901/lcs.git
#


class SuffixTree
  def initialize(s)
    @st = [{  :len => 0,
             :link => -1 }]

    @node = 1

    s.each_char { |c|
      @st = add_node(@st, c)
    }
  end

  def get
    @st
  end

  private

  def clone(st, curr, c)
    tmp_node = st[curr][:next][c]
    if (st[curr][:len] + 1) == st[tmp_node][:len]
      st[@node][:link] = tmp_node
    else
      st[@node][:len]  = st[curr][:len] + 1
      st[@node][:next] = st[tmp_node][:next]
      st[@node][:link] = st[tmp_node][:link]

      while  curr!=-1 && st[curr][:next][c] == tmp_node do
        st[curr][:next][c] = @node
        curr = st[curr][:link]
      end

      st[tmp_node][:link] = st[@node][:link] = @node
      @node += 1
    end
 
    return st
  end

  def add_node (st, c)
    last = st.size - 1

    st[@node] = {} 
    st[last][:next] = {}

    curr = last
    st[@node][:len] = st[last][:len] + 1

    while  curr!=-1 && !st[curr][:next].has_key?(c) do
      st[curr][:next][c] = @node
      curr = st[curr][:link]
    end

    if (curr == -1)
      st[@node][:link] = 0
    else
      st = clone(st, curr, c)
    end

    @node += 1

    return st
  end
end

def lcs (st, t)
  tmp_node = lenght = best = bestpos = 0

  t.each_char.to_a.each_with_index { |c, i|
    if st[tmp_node][:next].nil?
      tmp_node = st[tmp_node][:link]
      lenght = st[tmp_node][:len]
    end
    
    while ((tmp_node != 0) && !st[tmp_node][:next].has_key?(c)) do
      tmp_node = st[tmp_node][:link]
      lenght = st[tmp_node][:len]
    end


    if (st[tmp_node][:next].has_key?(c))
      tmp_node = st[tmp_node][:next][c]
      lenght += 1
    end

    if (lenght > best)
      best = lenght
      bestpos = i
    end

  }

  return t[bestpos-best+1,best]
end


#Read input data
lines = []
ARGF.each_with_index do |line, i|
   lines.push(line)
end

count=lines.shift.to_i


if !(1...11).member?(count)
  abort("Failed: Rows = #{count}. The number of rows must be like this: 1<=k<=10")
end

lines = lines.sort

subs = lcs(SuffixTree.new(lines[0].chomp).get, lines[1].chomp)

lines.shift(2)

lines.each_with_index { |line, i|
  subs = lcs(SuffixTree.new(subs).get, line.chomp)

  if (i + 1) >= count
    break
  end
}

p subs
