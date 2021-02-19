# DATO.RSS
*A seamless RSS Search Engine experience with a hint of Machine Learning.*

# BETA

Dato.RSS is in beta (launched 15 days ago), and will likely see many changes in the near future.

If you have comments or suggestions, please send them to us using the Issues TAB.

Thanks for trying the beta!


![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/x7e9tpkq0hc3ql70zzp5.png)

**Search Engine:** Quickly search through the millions of available RSS feeds.

**RESTful API:** Turns feed data into an awesome API. The API simplifies how you handle RSS, Atom, or JSON feeds. You can add and keep track of your favourite feed data with a simple, fast and clean REST API. All entries are enriched by Machine Learning and Semantic engines.

## Live

https://datorss.com

## Example

``` bash

curl 'https://datorss.com/api/searches?q=news' | json_pp

{
  "data": [
    {
      "id": "86b0f829-e300-4eef-82e1-82f34d03aff6",
      "type": "entry",
      "attributes": {
        "title": "\"Pandemic, Infodemic\": 2 Cartoon Characters Battling Fake News In Assam",
        "url": "https://www.ndtv.com/india-news/coronavirus-pandemic-infodemic-2-cartoon-characters-battling-fake-news-in-assam-2222333",
        "published_at": 1588448805,
        "body": "An English daily in Assam's Guwahati has been publishing a cartoon strip to tackle the fake news related to the coronavirus pandemic. The two central characters- \"Pandemic and Infodemic\"- are being...<img src=\"http://feeds.feedburner.com/~r/NDTV-LatestNews/~4/lEmH201Q8jI\" height=\"1\" width=\"1\" alt=\"\"/>",
        "text": "An English daily in Assam's Guwahati has been publishing a cartoon strip to tackle the fake news related to the coronavirus pandemic. The two central characters- \"Pandemic and Infodemic\"- are being...",
        "categories": [
          "all india"
        ],
        "sentiment": null,
        "parent": {
          "id": "c97bdae6-b5d1-4966-b9f3-615e29d4d47d",
          "title": "NDTV News  -  Special",
          "url": "feed:http://feeds.feedburner.com/NDTV-LatestNews",
          "rank": 99
        },
        "tags": []
      },
      "relationships": {
        "feed": {
          "data": {
            "id": "c97bdae6-b5d1-4966-b9f3-615e29d4d47d",
            "type": "feed"
          }
        }
      }
    },
  ]
}

```
## Search

Search is just implemented with Full Text Search Postgres feature.

I used the *pg_search Gem*, which can be used in two ways:

**Multi Search:** Search across multiple models and return a single array of results. Imagine having three models: Product, Brand, and Review. Using Multi Search we could search across all of them at the same time, seeing a single set of search results. This would be perfect for adding federated search functionality to your app.

**Search Scope:** Search within a single model, but with greater flexibility.

```sql
    execute <<-SQL
      ALTER TABLE entries
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('simple', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(body,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(url,'')), 'C')
      ) STORED;
    SQL
```


## Feed Rank

Feed Ranking is provided by [openrank](https://openrank.io) a free root domain authority metric based on the common search pagerank dataset. The value is normilized by 

```ruby
((Math.log10(domain_rank) / Math.log10(100)) * 100).round
```

## Machine Learning

Machine Learning is provided by [dandelion API](https://dandelion.eu) Semantic Text Analytics as a service, from text to actionable data. Extract meaning from unstructured text and put it in context with a simple API.

# Add Feed

At the moment is not possible to add source Feed if you have feed proposals open an issue with the URLs to add

https://github.com/davidesantangelo/dato.rss/issues

## Wiki

All API documentation is in the Wiki section. Feel free to make it better, of course.

https://github.com/davidesantangelo/dato.rss/wiki

To use some features such as adding a new feed you need a token with **write** permission. Currently only I can enable it. In case contact me

## Built With

- [Ruby on Rails](https://github.com/rails/rails) &mdash; Our back end API is a Rails app. It responds to requests RESTfully in JSON.
- [PostgreSQL](https://www.postgresql.org/) &mdash; Our main data store is in Postgres.
- [Redis](https://redis.io/) &mdash; We use Redis as a cache and for transient data.
- [Feedjira](https://github.com/feedjira/feedjira) &mdash; Feedjira is a Ruby library designed to parse feeds.
- [Dandelion](https://dandelion.eu) &mdash; Semantic Text Analytics as a service.
- [Sidekiq](http://sidekiq.org) &mdash; Simple, efficient background processing for Ruby.
- [JSON:API Serialization](https://github.com/jsonapi-serializer/jsonapi-serializer) &mdash; A fast JSON:API serializer for Ruby Objects..
- [PgSearch](https://github.com/Casecommons/pg_search) &mdash; PgSearch builds named scopes that take advantage of PostgreSQL's full text search.
- [TailwindCSS](https://github.com/tailwindlabs/tailwindcss) &mdash; A utility-first CSS framework for rapidly building custom user interfaces.

Plus *lots* of Ruby Gems, a complete list of which is at [/main/Gemfile](https://github.com/davidesantangelo/dato.rss/blob/main/Gemfile).

## Sponsor me

If you want to support me in server costs to keep dato.ess free and up, consider sponsorize! Thanks!

<a href="https://github.com/sponsors/davidesantangelo" target="_blank">GitHub sponsor</a>


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidesantangelo/dato.rss. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
