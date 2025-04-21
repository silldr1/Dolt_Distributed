## Dolt Demo Script

Overview:
Docker intro (not needed for higher level intro)
Limitations
Local Area - Main, commits, working, diffs
Branches - merging, reviewing
Remote - syncing, repository, stages
Distributed overview - conflicts, etc



### Limitations:

Due to the workbench UI there are some capabilities that can't be done

Limited Merging and Pulling
- Need to make sure that you checkout and create correct branches
- Utilize pull requests and merges
- Don't pull while on main branch

Can't Revert to commits from UI

There is much more functionality in the CLI as well as DoltLab itself. 

Because of these limitations I won't be able to show much for conflict handling unless I want to enter the CLI - which is probably too in the weeds for this

Data Shape limitations
- Because I haven't restructured data I am limited in capability
- 3rd Normalization mandates structure
- Can't delete rows unless at the bottom of the ER diagram

These problems will get ironed out when the data shape changes due to the fact that normalization requirements won't be as strict

MySQL
- MySQL is purely relationship based which makes it difficult to stuff objects
- Postgres based dolt is in beta - going to switch to that soon


## Demo

1. Rebuild the container
2. Open workbench
3. Main Commit Log
    a. navigate to main commit log
    b. point out timeline, hash, author, etc
    c. make a couple commits
    d. review the diffs of those commits
        -  Can revert at anytime - not in UI have to create a branch
4. Branching
    a. create an exercise branch
    b. remove a satellite frequency and section satellite
        - these are the only things I can delete
    c. commit changes
    d. switch back to main and show different log
5. Merging
    a. Initiate a pull request
    b. walk through changes in db
    c. Merge pull requests
    d. Inspect logs
    e. Make updates on main that you want to rebase into other branch
    f. Pull request from main to other branch
        - Point out no option to delete main branch
6. Pull from remote at other nodes
    a. show log at other nodes
    b. explain the pulling process
    c. make a commit
        - Explain how commit is in repo but not at other nodes
    d. look at the commit diff - small size
    e. pull from node 2 and then commit
    f. pull from remote and show log, highlight author

    All nodes are contributing to a single consistent history
    No change is left behind, no node is left behing
    Easy collaboration

## Demo Notes
