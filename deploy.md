# 部署流程 #

0. QA 提出测试计划，请求部署测试环境。

1. 发布人从master分支检出test分支，并部署。

        $ cap dev deploy # 10.18.103.252:6004

  - 需要修复时功能负责人可直接在test分支进行修改。
  - test非长久分支，每次从master重新检出，并记录修改。

2. staging阶段

        $ git merge test
        $ cap staging deploy # staging.umeng.com

  - 需要修复时功能负责人可在test分支进行修改，通过测试后可merge进staging分支。
  - staging为长久分支，原则上其log只允许merge操作。除test分支外，hot-fix也应并入staging。

3. stable阶段

        $ git merge staging
        $ cap HOSTS=10.18.10.39 production deploy # production backup
        $ cap HOSTS=10.18.10.38 production deploy # production

  - stable为长久分支，原则上其log只允许merge staging操作。

4. 部署结束，将stable分支并入master

