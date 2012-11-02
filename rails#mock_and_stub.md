1. **mock**

    ```ruby
    echo = mock('echo')
    echo.should_receive('sound').with('hey').and_return('hey')

    # as_null_object
    null_object = mock('null', :null_object => true)
    ```

2. **stub**

    ```ruby
    echo.stub(:every_method)

    # equels
    echo = stub('echo', :every_method => 'expected_result')

    # stub_chain
    # blogpost.recent.drafts.count
    BlogPost.stub_chain(:recent, :drafts, :count).and_return([stub, stub, stub])
    ```

3. **mock_model**

        mock_model(Foo)

  - make a mock object that pretends to be an ActiveRecord object.
  - autogenerate numeric ids and few methods stubbed out:

        id
        to_param
        new_record?
        errors
        is_a

4\. **stub_model**

    stub_model(Foo)

  - make a real model instance, but **YELLS** at operations on database. stub_model prohibits the model instance from accessing the database.
  - no need to explicit about its attributes, cause they are read from db, with a similia effect using `mock_model(Foo).as_null_object`

  - **memo** here: _as_null_object_ is used to ignore any messages that aren't explicitly set as stubs or message expectations.

