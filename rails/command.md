* rake notes

    ```ruby
    NOTES_TYPE = ['FIXME', 'OPTIMIZE', 'TODO']
    $ rake notes
    $ rake notes:fixme
    $ rake notes:optimize
    $ rake notes:todo
# custom, specify by ANNOTATION, put in code '# BUG to fix'
    $ rake notes:custom
    $ rake notes:custom ANNOTATION=BUG
    ```

* normal

    ```ruby
    $ rails plugin install https://github.com/technoweenie/acts_as_paranoid.git

    $ rake -T # => rake --task

    $ rake about # => about environment

    $ rake stats # => code statistics
    ```
