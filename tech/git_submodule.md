## git submodule

#### Basic commands:

+ `git submodule init`, register submodule into `.git/config`, used in repo initialization.
+ `git submodule update`, update submodule, used in daily work.

+ `git submodule foreach git pull`, git pull all submodules

#### How to clone and register a submodule?


+ 1st step 

	  $ git submodule add git@github.com:xxx/some-repo.git

  this will generate a `.gitmodules` files. looks like this:

	  [submodule "gmarik-vundle"]
  	  path = gmarik-vundle
  	  url = git://github.com/gmarik/vundle.git
  	
+ 2nd step

	  $ git add .gitmodules some-repo
	  $ git commit


	- `.gitmodules` records the submodule info for the parent.
	- Parent git need to record the submodule commit id to do version control.

+ 3rd step

  register submodule into .git/config

	  $ git submodule init

	
#### How to update a submodule from remote?


	$ cd some-repo
	$ git pull origin master
	
Remember: always commit a submodule update to help parent git do version control.
	  
	$ cd ..
	$ git add some-repo
	$ git commit
	  


#### How to update and commit a submodule?

+ One commit in submodule

	  $ cd some-repo
	  $ touch README
	  $ git commit
	  $ git push
	  
+ One commit in parent git

	  $ git add some-repo
	  $ git commit
	  $ git push
	
#### How to remove a submodule?

+ 1st step

	  $ git rm --cached some-repo
	  $ rm -rf some-repo
	  
+ 2nd step

	  $ vim .gitmodules
	  # remove some-repo

+ 3rd step

	  $ vim .git/config
	  # remove some-repo
	  
+ 4th step

	  $ git add --all
	  $ git commit
	  
+ 5th step

	  $ git submodule sync
	  
	> Synchronizes submodules' remote URL configuration setting to the value specified in .gitmodules. It will only affect those submodules which already have a URL entry in .git/config (that is the case when they are initialized or freshly added). This is useful when submodule URLs change upstream and you need to update your local repositories accordingly.

