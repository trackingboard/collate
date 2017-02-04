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

To use collate in a model, include several collation definitions. The first argument is the name of the database column to use in the query. The simplest example looks like this:

```
collate_on :name
```

This will add a filter to the model that will grab all records where the ```name``` column equals the parameter that is passed in.

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

### Additional Arguments

There are many other additional arguments you can initialize a filter with. Here is a list of all of them:

#### Label
--------------
```
collate_on :name, label: 'Character Name'
```

This argument will overwrite the default label for the filter, which is ```field.to_s.titleize```

#### Not
--------------
```
collate_on :name, not: true
```

This argument causes the entire query to be surrounded by a NOT(). The above, for example, translates to this PostgreSQL:

```
WHERE NOT(name = ?)
```

#### Having
--------------
```
collate_on :name, having: true
```

This argument tells the gem to use ```having``` instead of ```where``` in the ActiveRecord query. The above example then becomes:

```
HAVING name = ?
```

#### Joins
--------------
```
collate_on 'genres.id', operator: :in, joins: [:genres, :movies => [:people]]
```

This argument tells the gem to use the ActiveRecord ```joins``` method with the value passed in. You can pass in an array of values, and it will evaluate each one in succession. The above code would then run this before any query is evaluated:

```
ar_rel = ar_rel.joins(:genres)
ar_rel = ar_rel.joins(:movies => [:people])
```

#### Joins_prefix
--------------
```
collate_on 'select_genres.id', operator: :in, joins: [:genres], joins_prefix: 'select_'
```

This argument will tell the gem to join in the relations specified in the ```joins``` argument, but to prefix all table names with the prefix specified. The above code would then translate to the following PostgreSQL:

```
INNER JOIN genres AS select_genres ON ...
```

#### Component
--------------
```
collate_on 'genres.id', operator: :in, component: {load_records: true}
```

This argument is used for rendering in the views. Currently the gem does not have helper methods for the views, but when those are added, that is how you would set the various options.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trackingboard/collate.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

