# Collate

[![CircleCI](https://img.shields.io/circleci/project/github/trackingboard/collate.svg)](https://circleci.com/gh/trackingboard/collate)
[![Coveralls](https://img.shields.io/coveralls/trackingboard/collate.svg)](https://coveralls.io/github/trackingboard/collate?branch=master)
[![Gem](https://img.shields.io/gem/v/collate.svg)](https://rubygems.org/gems/collate)
[![Gem](https://img.shields.io/gem/dt/collate.svg)](https://rubygems.org/gems/collate)

## Installation

```gem install collate```

or with bundler in your Gemfile:

```gem 'collate'```

## Filter Usage

This gem currently only supports PostgreSQL.

To use collate filtering in a model, include several collation definitions. The first argument is the name of the database column to use in the query. The simplest example looks like this:

```
class Person < ActiveRecord::Base
	collate_on :name
end
```

This will add a filter to the model that will grab all records where the ```name``` column equals the parameter that is passed in.

Then you only need to use the ```collate``` method in the controller, passing the params:

```
@people = Person.collate(params)
```

The params key needs to match the key that the gem is expecting. You can currently find out what that key is by iterating over the ```collate_filters``` hash on the model's class, or you can create a filter that matches the definition in the model, and grab the param_key like this:

```
filter = Collate::Filter.new(:name, base_model_table_name: "people")

params[filter.param_key] = 'John Doe'

@people = Person.collate(params)
```

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

Field transformations are database functions applied to a field before the operator is used to compare it with the value. Field transformations are passed in as an array of tuples, where the first element in the tuple is the symbol for the transfomation, and the second element is the first argument to the database function.

For example:

```
collate_on :name, field_transformations: [[:split, ' ']]
```

This would translate to this PostgreSQL query:

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

Translates to this PostgreSQL query:

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
| ```:as_array```    | ```value = "{#{value}}"``` |
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

#### Or
--------------
```
collate_on :name, or: true
```

This argument causes the query to use "OR" for each element of the filter value array passed in from the user. For example, if the user passed in ```["John Doe", "Jane Doe"]``` as the parameter for the above collation, this is the PostgreSQL query that would result:

```
WHERE name = "John Doe" OR name = "Jane Doe"
```

#### Not
--------------
```
collate_on :name, not: true
```

This argument causes the entire query to be surrounded by a NOT(). The above, for example, translates to this PostgreSQL query:

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

This argument will tell the gem to join in the relations specified in the ```joins``` argument, but to prefix all table names with the prefix specified. The above code would then translate to the following PostgreSQL query:

```
INNER JOIN genres AS select_genres ON ...
```

#### Component
--------------
```
collate_on 'genres.id', operator: :in, component: {load_records: true}
```

This argument is used for rendering in the views. Currently the gem does not have helper methods for the views, but when those are added, that is how you would set the various options.

### The View

To know the ```params``` key to use for each filter, you need to look at the filter's ```param_key``` method value. The filters are organized in a hierarchal scheme in the class variable ```collate_filters``` for the model you included the DSL on.

Here is a small example of a few filters:

```
class Person < ActiveRecord::Base
	collate_on :name, operator: :ilike
	collate_on :birthday, operator: :le, label: 'Birthday Before'
end
```

And here is how ```Person.collate_filters``` would look like:

```
{
	:main=> {
		:label=>"Main",
		:filters=> [
			#<Collate::Filter
			@base_model_table_name="people",
			@component={:type=>"string"},
			@field="people.name",
			@field_transformations={},
			@grouping=nil,
			@html_id="1people_name",
			@joins=nil,
			@label="Name",
			@operator=:ilike,
			@value_transformations={}>
			,
			#<Collate::Filter
			@base_model_table_name="people",
			@component={:type=>"string"},
			@field="people.birthday",
			@field_transformations={},
			@grouping=nil,
			@html_id="1people_name",
			@joins=nil,
			@label="Birthday Before",
			@operator=:le,
			@value_transformations={}>
		]
	}
}
```

In order to use this in a view, you could have some HAML like this:

```
= form_tag '', :method => :get do
	- Person.collate_filters.each do |group_key, group|
		- filters = group[:filters]
		- filters.each do |filter|
			- case filter.component[:type]
			- when "string"
	  			= filter.label
	  			%br
	  			= text_field_tag filter.param_key, params[filter.param_key], id: "#{filter.html_id}", style:'width:100%'

```

This will ensure that the keys that the inputs are submitted with match the parameter key that the gem is expecting for that specific filter.

## Sorting Usage

To use collate sorting for a model, include several ```collate_sort``` defintions. For example:

```
class Person < ActiveRecord::Base
	collate_sort :name
	collate_sort :popularity	
end
```

Then, in the controller, use the ```collate``` method:

```
@people = Person.collate(params)
```

This will cause the people to be sorted on either ```name``` or ```popularity``` if the ```params[:order]``` value is set appropriately.

```params[:order]``` must have a value of the format ```"#{table_name}.#{field_name} ASC``` or ```"#{table_name}.#{field_name} DESC```

For example:

```
params[:order] = "people.name ASC"
@people = Person.collate(params)
```

Will result in the following PostgreSQL query:

```
SELECT * FROM people ORDER BY people.name ASC
```

You can also pass parameter options to ```collate_sort``` for more complex sorting.

#### Default
--------------
```
collate_sort :name, default: 'asc'
```

This tells collate that this particular sorting should be performed if there is no other sorting specified by the user.

It is also the second sorting to be applied on top of another sort.

For instance:

```
class Person < ActiveRecord::Base
	collate_sort :name, default: 'desc'
	collate_sort :popularity	
end
```

```
params[:order] = 'people.popularity ASC'
@people = Person.collate(params)
```

This would result in the following PostgreSQL query:

```
ORDER BY people.popularity ASC, people.name DESC
```

#### Joins
--------------
```
collate_sort 'posts.created_at', joins: [:posts]
```

This will perform the ActiveRecord joins before the sorting is applied. Doing this will allow you to sort on fields that are on related models.

#### Field_select
--------------
```
collate_sort 'post_count', joins: [:posts], field_select: 'COUNT(posts.*) as post_count'
```

This will perform the ActiveRecord select before the sorting is applied. Doing this will allow you to sort on fields created using a subquery.

#### Nulls_first
--------------
```
collate_sort :popularity, nulls_first: true
```

This will append ```NULLS FIRST``` to the order portion of the database query

#### Nulls_last
--------------
```
collate_sort :popularity, nulls_last: true
```

This will append ```NULLS LAST``` to the order portion of the database query

#### Label
--------------
```
collate_sort :popularity, label: 'Popularity Score'
```

This will modify the default sorting label, which is ```field.to_s.titleize```.

#### Asc_label
--------------
```
collate_sort :popularity, asc_label: 'Popularity Score Lowest to Highest'
```

This will modify the default ascending sorting label, which is ```#{label} ⬇```.

#### Desc_label
--------------
```
collate_sort :popularity, desc_label: 'Popularity Score Highest to Lowest'
```

This will modify the default descending sorting label, which is ```#{label} ⬆```.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trackingboard/collate.

1. Fork.
2. Branch.
3. Pull Request your feature branch or fix.
4. 🍕

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
