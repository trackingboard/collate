action_genre = Genre.create!(
  name: "Action"
)
scifi_genre = Genre.create!(
  name: "Science Fiction"
)

Director.create!(
  name: "Steven Spielberg"
)

nick = Actor.create!(
  name:         'Nick',
  popularity:   90
)

colleen = Actor.create!(
  name:         'Colleen',
  popularity:   91
)

shannon = Actor.create!(
  name: 'Shannon'
)

bttf = Movie.create!(
  name: "Back to the Future",
  genre_ids: [action_genre.id, scifi_genre.id],
  good_movie: true,
  release_date: Date.new(2017, 1, 31),
  synopsis: "Master cleanse actually crucifix, biodiesel cred celiac VHS listicle craft beer meh. Next level hammock hot chicken, authentic tumeric tilde dreamcatcher woke vinyl master cleanse slow-carb ethical quinoa. Pop-up put a bird on it keffiyeh, umami DIY jianbing asymmetrical artisan forage lumbersexual taxidermy hella. Fingerstache pour-over meggings mumblecore bushwick small batch, meh +1 cold-pressed forage typewriter craft beer tilde air plant.",
  user_rating: nil,
  director_id: Director.first.id,
  mpaa_rating: 'R'
)

marty = Character.create!(
  actor_id: nick.id,
  movie_id: bttf.id,
  name: 'Marty McFly',
  order: 1
)
doc = Character.create!(
  actor_id: colleen.id,
  movie_id: bttf.id,
  name: 'Doctor Emmett Brown',
  order: 2
)

Movie.create!(
  name: "Twelve Monkeys",
  genre_ids: [action_genre.id, scifi_genre.id],
  good_movie: true,
  release_date: Date.new(2016, 1, 31),
  synopsis: "Everyday carry jean shorts cred, yuccie messenger bag aesthetic intelligentsia.",
  user_rating: 7,
  mpaa_rating: 'R'
)
jack_reacher = Movie.create!(
  name: "Jack Reacher: Never Go Back",
  genre_ids: [action_genre.id],
  good_movie: false,
  release_date: Date.new(1987, 6, 29),
  synopsis: "XOXO disrupt bicycle rights, PBR&B thundercats tilde blog YOLO iceland gochujang kickstarter. Food truck swag green juice bicycle rights cred. Helvetica mlkshk 8-bit aesthetic readymade, ennui gochujang franzen. Before they sold out hell of messenger bag typewriter celiac, ennui cardigan ramps copper mug shabby chic pickled 8-bit artisan irony DIY",
  user_rating: 5,
  mpaa_rating: 'PG13'
)

jack = Character.create!(
  actor_id: shannon.id,
  movie_id: jack_reacher.id,
  name: 'Jack'
)
