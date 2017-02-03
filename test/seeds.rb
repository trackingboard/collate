action_genre = Genre.create!(
  name: "Action"
)
scifi_genre = Genre.create!(
  name: "Science Fiction"
)

Movie.create!(
  name: "Back to the Future",
  genre_ids: [action_genre.id, scifi_genre.id]
)
Movie.create!(
  name: "Twelve Monkeys"
)
Movie.create!(
  name: "Jack Reacher: Never Go Back"
)