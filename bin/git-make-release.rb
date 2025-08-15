#!/usr/bin/env -S ruby
# -*- Mode:ruby; Coding:us-ascii; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      git-makek-release.rb
# @author    Mitch Richling http://www.mitchr.me/
# @brief     Helper to make a software releases with git.@EOL
# @std       Ruby 3
# @see       https://github.com/richmit/codeBits/
# @copyright 
#  @parblock
#  Copyright (c) 2024, Mitchell Jay Richling <http://www.mitchr.me/> All rights reserved.
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
#  #  @endparblock
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
require 'digest/sha1' 
require 'fileutils' 
require 'optparse'
require 'optparse/time'

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Set defaults and process command line arguments
verNumb=nil
justChecking=false
updateManifest=false
opts = OptionParser.new do |opts|
  opts.banner = "Usage: git-make-release.rb [options]"
  opts.separator ""
  opts.separator "Options:"
  opts.on("-h",     "--help",       "Show this message")                       { puts opts; exit            }
  opts.on("-t VER", "--tag VER",    "Create release tag from VERsion number")  { |v| verNumb = v            }
  opts.separator "                          Must be a date (YYYY-MM-DD) or FOUR non-zero       "
  opts.separator "                          padded integers separated by single periods.       "
  opts.on("-m",     "--manifest",   "Generate/update MANIFEST.txt file")       { |v| updateManifest = true  }
  opts.separator "                                      For proper operation at least one of   "
  opts.separator "                                      options -t or -m must be present.      "
  opts.on("-c",     "--check",      "Do not make any git changes")             { |v| justChecking = true    }
  opts.separator "                                      With -t, check tag rules but do not    "
  opts.separator "                                      not create the tag.  With -m, update   "
  opts.separator "                                      MANIFEST.txt but do not commit to git. "
  opts.separator "                                                                             "
  opts.separator "This script prepares a formal software release from the current branch       "
  opts.separator "HEAD in git.  By 'formal software release' I mean the following:             "
  opts.separator "  - A version number has been defined (four integers separated by periods)   "
  opts.separator "  - Check that the version number is consistent                              "
  opts.separator "    - The git repo must be clean                                             "
  opts.separator "    - The tag ('v' followed by the version number) for this release must not "
  opts.separator "      already exist                                                          "
  opts.separator "    - Tag message file named 'next-tag.org' must exist                       "
  opts.separator "      - It must have at least 3 lines of text                                "
  opts.separator "      - The first line may not start with white-space                        "
  opts.separator "      - The first line must be at least 5 characters long                    "
  opts.separator "      - The second line must be completely empty                             "
  opts.separator "      - The third line must contain at least 5 characters                    "
  opts.separator "    - For cmake projects, make sure the VERSION value in PROJECT matches the "
  opts.separator "      provided version number                                                "
  opts.separator "    - Doxygen documentation has been deployed with the correct tag-name      "
  opts.separator "    - The changelog.org file has an entry for this version, and              "
  opts.separator "      changelog.html is up to date                                           "
  opts.separator "    - TAGS files, if they exist, in lib/ & src/ are up to date.              "
  opts.separator "  - If everything is OK, then this script can perform the following actions: "
  opts.separator "    - Create a release tag on HEAD ('v' followed by the version number)      "
  opts.separator "    - Create/update MANIFEST.txt and commit it to git if necessary           "
  opts.separator "                                                                             "
  opts.separator "MANIFEST Generation:                                                         "
  opts.separator "  - Only files in GIT with a working version checked out make it into        "
  opts.separator "    the MANIFEST.txt file.                                                   "
  opts.separator "  - A temporary file called TSEFINAM.txt is created in the CWD.              "
  opts.separator "                                                                             "
  opts.separator "Recipes                                                                      "
  opts.separator "  - Just check if a version number is OK to use:                             "
  opts.separator "      git-make-release.rb -ct VERSION_NUMBER                                 "
  opts.separator "  - Check if a version number is OK and update MANIFEST.txt (no commit):     "
  opts.separator "      git-make-release.rb -cmt VERSION_NUMBER                                "
  opts.separator "  - Update MANIFEST.txt if necessary, but don't commit it to git:            "
  opts.separator "      git-make-release.rb -mc                                                "
  opts.separator "  - Create a release with tag and good MANIFEST.txt                          "
  opts.separator "      git-make-release.rb -mt VERSION_NUMBER                                 "
  opts.separator "  - Create a release with tag without updating MANIFEST.txt                  "
  opts.separator "      git-make-release.rb -t VERSION_NUMBER                                  "
  opts.separator "  - Update MANIFEST.txt if necessary and commit it to git if necessary:      "
  opts.separator "      git-make-release.rb -mc                                                "

end
opts.parse!(ARGV)

if (verNumb.nil? && !(updateManifest)) then
  puts("ERRR(git-make-release.rb): This script requires at least one of the '-t TAG' or '-m' options!")
  exit 1
end

if justChecking then
  puts("INFO(git-make-release.rb): Check mode!")
end

if !(FileTest.directory?('.git')) then
  puts("ERRR(git-make-release.rb): Could not find .git!  Are we in a git repo?")
  if !(justChecking) then
    exit 1
  end
end

git_out = `git status --porcelain --untracked-files=no`
if !(git_out.empty?) then
  puts("ERRR(git-make-release.rb): The git repository has uncommitted changes in tracked files!")
  if !(justChecking) then
    exit 1
  end
end

if verNumb.nil? then
  if justChecking then
    puts("INFO(git-make-release.rb): No version number provided.  Not checking release tag rules. ")
  else
    puts("INFO(git-make-release.rb): No version number provided.  Not creating/checking release Tag. ")
  end
else
  puts("INFO(git-make-release.rb): Version number provided: #{verNumb}")

  if (verNumb.match(/^(\d\d\d\d)-(\d\d)-(\d\d)$/)) then
    puts("INFO(git-make-release.rb): Version number is a date string. ")
    if (verNumb != Time.now.strftime('%Y-%m-%d')) then
      puts("ERRR(git-make-release.rb): Date version number must be a today!")
      if !(justChecking) then
        exit 1
      end
    end
  else
    tmp = verNumb.match(/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/)
    if !(tmp) then
      puts("ERRR(git-make-release.rb): Version number is malformed (should be a date or four integers separated by periods)!")
      if !(justChecking) then
        exit 1
      end
    else
      puts("INFO(git-make-release.rb): Version number is a traditional dotted 4-tuple. ")
    end

    ['1st', '2nd', '3rd', '4th'].each_with_index do |s, i|
      if tmp[i+1].match(/^0\d+$/) then
        puts("ERRR(git-make-release.rb): The #{s} component of #{verNumb} is zero padded!!")
        if !(justChecking) then
          exit 1
        end
      end
    end
  end

  tagName = 'v' + verNumb
  puts("INFO(git-make-release.rb): Tag name: #{tagName.inspect}")

  gitOut = `git show-ref --tags #{tagName}`
  if !(gitOut.empty?) then
    puts("ERRR(git-make-release.rb): Tag already exists!")
    if !(justChecking) then
      exit 1
    end
  end

  if !(FileTest.exist?('next-tag.org')) then
    puts("ERRR(git-make-release.rb): No 'next-tag.org' file exists!")
    if !(justChecking) then
      exit 1
    end
  end

  if FileTest.zero?('next-tag.org') then
    puts("ERRR(git-make-release.rb): The 'next-tag.org' exists, but is empty!")
    if !(justChecking) then
      exit 1
    end
  end

  open('next-tag.org', "r") do |file|
    line = file.readline
    if line.match(/^\s/) then
      puts("ERRR(git-make-release.rb): First line of 'next-tag.org' should not start with whitespace!")
      if !(justChecking) then
        exit 1
      end
    end
    if line.length < 5 then
      puts("ERRR(git-make-release.rb): First line of 'next-tag.org' should be longer than 5 characters!")
      if !(justChecking) then
        exit 1
      end
    end
    if file.eof? then
      puts("ERRR(git-make-release.rb): 'next-tag.org' must contain more than 1 line!")
      if !(justChecking) then
        exit 1
      end
    end
    line = file.readline
    if !(line.match(/^$/)) then
      puts("ERRR(git-make-release.rb): Second line of 'next-tag.org' should be blank!")
      if !(justChecking) then
        exit 1
      end
    end
    if file.eof? then
      puts("ERRR(git-make-release.rb): 'next-tag.org' must contain more than 2 line!")
      if !(justChecking) then
        exit 1
      end
    end
    line = file.readline
    if line.length < 5 then
      puts("ERRR(git-make-release.rb): Thrid line of 'next-tag.org' should be longer than 5 characters!")
      if !(justChecking) then
        exit 1
      end
    end
  end

  if FileTest.exist?('CMakeLists.txt') then
    puts("INFO(git-make-release.rb): Found CMakeLists.txt")
    verRe = Regexp.new('^project\((.+?)VERSION\s+([0-9.]+)(.+?)\)\s', Regexp::EXTENDED | Regexp::IGNORECASE | Regexp::MULTILINE)
    open("CMakeLists.txt", "r") do |file|
      cmakelists = file.read()
      tmp = verRe.match(cmakelists)
      if (tmp) then
        cmakeProjVers = tmp[2]
        if (cmakeProjVers != verNumb) then
          puts("ERRR(git-make-release.rb): CMakeLists.txt version number #{cmakeProjVers.inspect} didn't match #{verNumb.inspect}!")
          if !(justChecking) then
            exit 1
          end
        else
          puts("INFO(git-make-release.rb): CMakeLists.txt version number matches!")
        end
      else
        puts("ERRR(git-make-release.rb): Version number not found in CMakeLists.txt!")
        if !(justChecking) then
          exit 1
        end
      end
    end
  end

  pubDoxyfile = File.join( ['/Users', 'richmit', 'MJR', 'WWW', 'site', 'SS'] + [ File.basename(FileUtils.pwd) ] + [ 'doc-lib', 'Doxyfile' ]);
  if FileTest.exist?(pubDoxyfile) then
    open(pubDoxyfile, "r") do |file|
      doxyfile = file.read()
      tmp = Regexp.new('PROJECT_NUMBER\s*=\s*"?([^\s"]+)"?\s*$').match(doxyfile)
      if (tmp) then
        doxVer = tmp[1]
        if (doxVer != verNumb) then
          puts("ERRR(git-make-release.rb): Deployed Doxygen version number #{doxVer.inspect} didn't match #{verNumb.inspect}!")
          if !(justChecking) then
            exit 1
          end
        else
          puts("INFO(git-make-release.rb): Deployed Doxygen version number matches!")
        end
      else
        puts("ERRR(git-make-release.rb): Deployed Doxygen is missing PROJECT_NUMBER!")
        if !(justChecking) then
          exit 1
        end
      end
    end
  else
    puts("WARN(git-make-release.rb): No published documentation found!")
  end

  changeLogFile = File.join( [ 'docs', 'changelog.org' ]);
  if FileTest.exist?(changeLogFile) then
    open(changeLogFile, "r") do |file|
      changelog = file.read()
      tmp = Regexp.new('^:CUSTOM_ID:\s*v' + Regexp.quote(verNumb) + '$').match(changelog)
      if (tmp) then
        puts("INFO(git-make-release.rb): changelog entry found for #{verNumb.inspect}!")
        if (FileUtils.uptodate?(changeLogFile.sub(/\.org$/, '.html'), [ changeLogFile ] )) then
          puts("INFO(git-make-release.rb): changelog.html is up to date!")
        else
          puts("ERRR(git-make-release.rb): changelog.html is out of date!")
          if !(justChecking) then
            exit 1
          end
        end
      else
        puts("ERRR(git-make-release.rb): no changelog entry found for #{verNumb.inspect}!")
        if !(justChecking) then
          exit 1
        end
      end
    end
  else
    puts("WARN(git-make-release.rb): No changelog.org file found!")
  end
end

# Check on html files generated from org files
dirsForOrgHtml = [ 'docs' ]
dirsForOrgHtml.each do |dir|
  orgFiles = Dir.glob("#{dir}/*.org")
  orgFiles.each do |orgFile|
    htmlFile = orgFile.sub(/org$/, 'html')
    if FileTest.exist?(htmlFile) then
      if (FileUtils.uptodate?(htmlFile, [ orgFile ] )) then
        puts("INFO(git-make-release.rb): #{htmlFile} is up to date!")
      else
        puts("ERRR(git-make-release.rb): #{htmlFile} is out of date (#{orgFile})!")
        if !(justChecking) then
          exit 1
        end
      end
    end
  end
end

['lib/', 'src/'].each do |dir|
  if FileTest.exist?("#{dir}/TAGS") then
    srcFiles = Array.new
    ['cc', 'h', 'c', 'hpp', 'cpp', 'f90', 'f'].each do |ext|
      srcFiles += Dir.glob("#{dir}/*.#{ext}")
    end
    if ( !(srcFiles.empty?) && !(FileUtils.uptodate?("#{dir}/TAGS", srcFiles))) then 
      puts("ERRR(git-make-release.rb): TAGS file (#{dir}/TAGS) out of date (#{ext} files)!")
      if !(justChecking) then
        exit 1
      end
    else
      puts("INFO(git-make-release.rb): TAGS file (#{dir}/TAGS) is up to date!")
    end
  end
end

if !(updateManifest) then
  if justChecking then
    puts("INFO(git-make-release.rb): Not updating MANIFEST.txt!")
  else
    puts("INFO(git-make-release.rb): Not updating or committing MANIFEST.txt!")
  end
else
  if justChecking then
    puts("INFO(git-make-release.rb): Updating MANIFEST.txt if required!")
  else
    puts("INFO(git-make-release.rb): Updating and committing MANIFEST.txt if required!")
  end

  manifestTracked = !(`git ls-files MANIFEST.txt`.empty?)

  if manifestTracked then
    puts("INFO(git-make-release.rb): MANIFEST.txt is tracked by git")
    if !(FileTest.exist?('MANIFEST.txt')) then
      puts("WARN(git-make-release.rb): MANIFEST.txt is not checked out!")
      system('git checkout MANIFEST.txt')
      if !(FileTest.exist?('MANIFEST.txt')) then
        puts("ERRR(git-make-release.rb): Could not checkout MANIFEST.txt!")
        if !(justChecking) then
          exit 1
        end
      end
    end
  else
    puts("WARN(git-make-release.rb): MANIFEST.txt is not tracked by git")
    if !(FileTest.exist?('MANIFEST.txt')) then    
      FileUtils.touch('MANIFEST.txt')
      if !(FileTest.exist?('MANIFEST.txt')) then
        puts("ERRR(git-make-release.rb): Could not create MANIFEST.txt!")
        exit 1
      end
    end
  end

  open('TSEFINAM.txt', 'w') do |ofile|
    ofile.printf("%-41s %s\n", "SHA1", "File Name")  
    IO.popen("git ls-files -s", 'r') do |pipe|
      pipe.each_line do |line|
        (modes, csum, numb, fname) = line.chomp.split(/\s+/, 4)
        if ((FileTest.exist?(fname)) and (fname != "MANIFEST.txt")) then
          fileDigest = nil
          open(fname, 'r') do |ofile|
            fileDigest = Digest::SHA1.hexdigest(ofile.read())
          end
          ofile.printf("%-41s %s\n", fileDigest, fname.inspect)
        end
      end
    end
  end

  manifestInGitOutdated = false
  if FileUtils.compare_file('TSEFINAM.txt', 'MANIFEST.txt') then
    if manifestTracked then
      puts("INFO(git-make-release.rb): Both working and committed copies of MANIFEST.txt were up to date")
    else
      puts("INFO(git-make-release.rb): MANIFEST.txt was up to date, but is untracked!")
      manifestInGitOutdated = true
    end
    FileUtils.rm('TSEFINAM.txt')
  else
    puts("INFO(git-make-release.rb): MANIFEST.txt was out of date and was updated")
    FileUtils.mv('TSEFINAM.txt', 'MANIFEST.txt')
    manifestInGitOutdated = true
  end

  if manifestInGitOutdated then
    if justChecking then
      puts("WARN(git-make-release.rb): NOT committing MANIFEST.txt to git")
    else
      puts("INFO(git-make-release.rb): Committing MANIFEST.txt to git")
      if !(manifestTracked) then
        system('git add MANIFEST.txt')
      end
      if verNumb.nil? then
        system("git commit -m 'Updated MANIFEST.txt' MANIFEST.txt")
      else
        system("git commit -m 'Updated MANIFEST.txt for v#{verNumb}' MANIFEST.txt")
      end
    end
  end
end

if !(justChecking) then
  gitOut = `git tag #{tagName} -F next-tag.org`
  if !(gitOut.empty?) then
    puts("ERRR(git-make-release.rb): Tag create produced output: #{gitOut.inspect}")
  end
  puts("\n\n\n")
  puts(`git tag -l -n100 #{tagName}`)
  puts("\n\n\n")
  puts("To push:")
  puts("    g p; g pt")
end
