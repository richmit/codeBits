#!/usr/bin/env -S ruby
# -*- Mode:ruby; Coding:us-ascii; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      git-find-n-status.rb
# @author    Mitch Richling http://www.mitchr.me/
# @brief     Find git repos, and report state.@EOL
# @std       Ruby 3
# @see       https://github.com/richmit/codeBits/
# @copyright 
#  @parblock
#  Copyright (c) 2025, Mitchell Jay Richling <http://www.mitchr.me/> All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#  
#  1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.
#  
#  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#  
#  3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software
#     without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
#  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
#  DAMAGE.
#  @endparblock
# @filedetails
#
#  Find git repos, and report state:
#        
#   - UNCOMMITED  Repo has uncommited changes
#   - UNTRACKED   Repo has untracked files
#   - UNPUSHED    Repo has commited changes that have not been pushed
#   - CLEAN LOCL  Repo is clean and has no remotes
#   - CLEAN REMT  Repo is clean and has remotes
#
#
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
require 'find'

# Print stuff to STDOUT immediatly -- important on windows
$stdout.sync = true

print_clean = true

puts("SCAN FOR GIT REPOS...")
repos = Array.new
Find.find(Dir.pwd()) do |path|
  if FileTest.directory?(path) then
    if File.basename(path) == ".git" then
      repos.push(File.dirname(path))
    end
  end
end

puts("  FOUND #{repos.length} REPOS")

puts("QUERY REPO STATUS...")
repos.each do |path|
  Dir.chdir(path) do
    # Get the name of the branch with a remote (main or master)
    main_branch = 'main'
    git_out = `git config --local branch.main.remote`
    if git_out.empty? then
      main_branch = 'master'
      git_out = `git config --local branch.master.remote`
    end
    # local or remote tag
    lor = 'REMOTE'
    if git_out.empty? then
      lor = 'LOCAL'
    end
    # How dirty is the repo

    how_dirty = 'CLEAN'
    git_out = `git status --porcelain --untracked-files=no`
    if !(git_out.empty?) then
      how_dirty = 'UNCOMMITED:'
    else
      git_out = `git status --porcelain`
      if !(git_out.empty?) then
        how_dirty = 'UNTRACKED:'
      else
        if lor == 'LOCAL' then
          how_dirty = 'CLEAN:'
        else
          git_out = `git rev-list --count origin/#{main_branch}..#{main_branch}`.to_i
          if git_out > 0 then
            how_dirty = 'UNPUSHED:'
          else
            if print_clean then
            how_dirty = 'CLEAN:'
            end
          end
        end
      end
    end
  # prit status
  printf("%7s %12s %s\n", lor, how_dirty, path)
  end
end
