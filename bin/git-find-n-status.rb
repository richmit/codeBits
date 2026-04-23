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
#  Find git repos, and report state for each repo: 
#        
#   - Location
#     - LOCAL       The main/master branch has no remote
#     - GITHUB      Repo has a remote main/master branch hosted github
#     - GITHUB!     Repo is GITHUB, but user email is incorrect.
#     - REMOTE      Repo has a remote main/master branch (not on github)
#   - Tracked file Status
#     - UNTRACKED   Repo has untracked files
#     - TRACKED     Repo has no untracked files
#   - Commit Status
#     - UNCOMMITED  Repo has uncommited changes to tracked files
#     - COMMITED    Repo has no uncommited changes to tracked files
#   - Push Status
#     - UNPUSHED    Repo has commits that have not been pushed
#     - PUSHED      All commits have been pushed
#     - LOCAL       Repo is local
#   Overall Status
#     - DIRTY       Repo is UNTRACKED or UNCOMMITED or UNPUSHED
#     - CLEAN       Repo is TRACKED and COMMITED and PUSHED
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
    loc = 'LOCAL'
    gh = false
    if !(git_out.empty?) then      
      git_out = `git config --local remote.#{git_out}.url`
      if (git_out.match(/github/)) then
        loc = 'REMOTE'
      else
        # github email used?
        git_out = `git config --local user.email`
        if (git_out.chomp == '11151403+richmit@users.noreply.github.com') then
          loc = 'GITHUB'
        else
          loc = 'GITHUB!'
        end
      end
    end
    # COMMITED / UNCOMMITED
    git_out = `git status --porcelain --untracked-files=no`
    cuc = !(git_out.match?(/^ M/m))
    # TRACKED / UNTRACKED
    git_out = `git status --porcelain`
    tut = !(git_out.match?(/^\?\?/m))
    # PUSHED / UNPUSHED
    pup = 'LOCAL'
    if (loc != 'LOCAL') then
      pup = (`git rev-list --count origin/#{main_branch}..#{main_branch}`.to_i <= 0)
    end
    # prit status
    printf("%-8s %10s %9s %8s %5s  %s\n", 
           loc, 
           (cuc               ? 'COMMITED' : 'UNCOMMITED'), 
           (tut               ? 'TRACKED'  : 'UNTRACKED'), 
           (pup               ? 'PUSHED'   : 'UNPUSHED'), 
           (cuc && tut && pup ? 'CLEAN'    : 'DIRTY'), 
           path)
  end
end
