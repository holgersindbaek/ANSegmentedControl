Pod::Spec.new do |s|
  s.name         = "ANSegmentedControl"
  s.version      = "0.0.1"
  s.summary      = "Reader for Mac like Animation NSSegmentedControl."
  s.homepage     = "https://github.com/Decors/ANSegmentedControl"
  s.author       = "Decors"
  s.source       = { :git => "https://github.com/Decors/ANSegmentedControl.git", :commit => "96844ff87246b9d9fade1fce90392aef1f5aa7f0" }
  s.license      = {
    :type => 'BSD',
    :text => <<-LICENSE
      Copyright (c) 2011-2013, Decors
      All rights reserved.

      Redistribution and use in source and binary forms, with or without
      modification, are permitted provided that the following conditions are met:
      1. Redistributions of source code must retain the above copyright
         notice, this list of conditions and the following disclaimer.
      2. Redistributions in binary form must reproduce the above copyright
         notice, this list of conditions and the following disclaimer in the
         documentation and/or other materials provided with the distribution.
      3. All advertising materials mentioning features or use of this software
         must display the following acknowledgement:
         This product includes software developed by the <organization>.
      4. Neither the name of the <organization> nor the
         names of its contributors may be used to endorse or promote products
         derived from this software without specific prior written permission.

      THIS SOFTWARE IS PROVIDED BY <COPYRIGHT HOLDER> ''AS IS'' AND ANY
      EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
      WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
      DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
      DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
      (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
      LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
      ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
      SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    LICENSE
  }
  s.dependency 'RHAdditions'
  s.platform     = :osx
  s.source_files = '*.{h,m}'
end