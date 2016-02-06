# APIable Model Errors

ActiveModel provides a great framework for handling validations
for models. It easily allows you to add any validation message to
any attribute however these arbitary strings aren't very helpful
if you want to deliver validation errors to APIs. API developers
don't want to see `Number is too long (maximum is 5 characters)`,
they would much rather see something they can handle internally.

This gem extends the `ActiveModel::Errors` class to allow for a
more API-friendly hash of errors to be returned.

## Installation

```ruby
gem "apiable_model_errors"
```

## Usage

Once you've installed the gems, you can call the `to_api_hash`
method on any `ActiveModel::Errors` object.

```ruby
user = User.new(params)
unless user.valid?
  user.errors.to_api_hash
end
```

## Example Output

When using this you'll receive a ruby hash however you can easily
convert this into JSON by calling `to_json` on the hash.

```javascript
{
  "name":[
    {
      "code":"too_long",
      "message":"is too long (maximum is 4 characters)",
      "options":{
        "count":4
      }
    }
  ]
}
```

As you can see you'll receive the code, the actual translated
message from ActiveModel and any options.

## `has_message?`

In addition to provide the `to_api_hash` method, we also provide
a method called `has_message?` which allows you to determine if a
message exists for a given attribute. This is similar to the
`added?` however does not require that you provide all options to
see if a message has been added.

```ruby
# See if there are any :too_long messages on the name attribute
user.errors.has_message?(:name, :too_long)
# See if there are any :too_long messages on the name attribute
# with the options provided.
user.errors.has_message?(:name, :too_long, :count => 4)
# See if there are any :blank messages on the name attribute
user.errors.has_message?(:name, :blank)
```
