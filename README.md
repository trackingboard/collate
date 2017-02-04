# Collate

[![CircleCI](https://img.shields.io/circleci/project/github/trackingboard/collate.svg)](https://circleci.com/gh/trackingboard/collate)
[![Coveralls](https://img.shields.io/coveralls/trackingboard/collate.svg)](https://coveralls.io/github/trackingboard/collate?branch=master)
[![Gem](https://img.shields.io/gem/v/collate.svg)]()
[![Gem](https://img.shields.io/gem/dt/collate.svg)]()

## Installation

```gem install collate```

or with bundler in your Gemfile:

```gem 'collate'```

## Usage

This gem currently only supports PostgreSQL.

To use collate in a model, include several collation definitions. The simplest example looks like this:

```
collate_on :name
```

This will add a filter to the model that will grab all records where the name equals the parameter that is passed in.

### Operators

You can currently collate using multiple types of operators. To specify an operator to collate on, you can pass in the keyword argument ```operator```, like this:

```
collate_on :name, operator: :ilike
```

Translates to:

```
WHERE name ILIKE ?
```

Here are the currently available operators:

| Operator | Behavior |
|:------------------|:--------------------|
| ```:eq```         | ```field = ?``` |
| ```:ilike```      | ```field ILIKE ?``` |
| ```:in```         | ```field IN (?)``` |
| ```:le```         | ```field <= ?``` |
| ```:ge```         | ```field >= ?``` |
| ```:null```       | ```field IS NULL``` |
| ```:contains```   | ```field @> ?``` |
| ```:present?```   | ```field = ?``` |
| ```:&```          | ```field & ?``` |

### Field Transformations

Field transformations are database functions used on a field before the operator is used to compare it with the value. Field transformations are passed in as an array of tuples, where the first element in the tuple is the symbol for the transfomation, and the second element is the first argument to the database function. 

For example:

```
collate_on :name, field_transformations: [[:split, ' ']]
```

This would translate to this PostgreSQL:

```
WHERE string_to_array(name, ' ') = ?
```

Here are the available field transformations:

| Transformation | Behavior |
|:-------------------------|:--------------------|
| ```:date_difference``` | ```date_difference(arg1, field)``` |
| ```:date_part```       | ```date_part(arg1, field)``` |
| ```:array_agg```       | ```array_agg(field)``` |
| ```:downcase```        | ```lower(field)``` |
| ```:split```           | ```string_to_array(field, arg1)``` |
| ```:array_length```    | ```array_length(field, arg1)``` |

These transformations can also be chained together on the same filter. They are applied in the order they appear in the array that is passed in.

For example:

```
collate_on :name, field_transformations: [[:split, ' '], [:array_length, 1]]
```

Translates to this PostgreSQL:

```
WHERE array_length(string_to_array(name, ' '), 1) = ?
```

### Value Transformations

Value transformations are functions applied to the user-supplied value before it is passed to the database query. They are passed in the same way as the field transmorations, as an array of tuples.

For example:

```
collate_on :name, value_transformations: [[:join, ', ']]
```

Translates to the following code:

```
value = value.join(', ')
ar_rel = ar_rel.where("name = ?", value)
```

Here are the available value transformations:

| Transformation | Behavior |
|:-------------------------|:--------------------|
| ```:join```        | ```value = value.join(arg1)``` |
| ```:downcase```    | ```value = value.downcase``` |
| ```:string_part``` | ```value = "%#{value}%"``` |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trackingboard/collate.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

