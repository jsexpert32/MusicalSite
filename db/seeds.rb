require 'faker'

# Remember to install ImageMagick + ffmpeg

def image_path( image )
  Rails.root.join( 'app', 'assets', 'images', 'seeds', image )
end

def audio_path( audio )
  Rails.root.join( 'app', 'assets', 'audios', audio )
end

def cover_file( name )
  File.open( image_path( name ) )
end

def audio_file(name)
  File.open( audio_path( name ) )
end

puts '***** Create demo users *****'
puts '\n\n'

User.skip_callback( :save, :after, :confirm_email )

user = User.new( email: 'demo@example.com',
                 password: '12345678',
                 password_confirmation: '12345678',
                 first_name: 'test', last_name: 'test',
                 city: 'indore', country: 'In',
                 username: 'BrockBerrigan',confirmed: true
                 )
user.save

# Random User create

100.times do
  password  = Faker::Internet.password

  user      = User.new(
    email:                  Faker::Internet.email,
    password:               password,
    password_confirmation:  password,
    first_name:             Faker::Name.first_name,
    last_name:              Faker::Name.last_name,
    city:                   Faker::Address.city,
    country:                Faker::Address.country,
    username:               Faker::Internet.user_name(4),
    confirmed:              true
                   )

  user.save
end

User.set_callback(:save, :after, :confirm_email)

puts 'Users created!'
puts '\n\n'

# Creating the seed for Genre

puts '********* CREATING GENRE LIST ***********'
puts '\n\n'

hip_hop = Genre.find_by(name: 'Hip-Hop') || Genre.create!( { name: 'Hip-Hop' } )

subgenres = [
  { name: 'ALTERNATIVE' },
  { name: 'BOOM BAP' },
  { name: 'EAST COAST' },
  { name: 'EXPERIMENTAL' },
  { name: 'GANGSTER' },
  { name: 'HARDCORE' },
  { name: 'JAZZY' },
  { name: 'SOULFUL' },
  { name: 'TRAP' },
  { name: 'CHILLHOP' },
  { name: 'TRIPPY' },
  { name: 'UNDERGROUND' },
  { name: 'WEST COAST' }
].map do |h|
  h.merge( genre_id: hip_hop.id )
end

Subgenre.create!( subgenres )

genres    = Genre.pluck(:id)
subgenres = Subgenre.pluck(:id)

puts '********* CREATED GENRE LIST ***********'
puts '\n\n'


# Creating the Types of Artists
puts '**** Creating Artist List ****'
puts '\n\n'

ArtistType.create([{name: 'Kendrick Lamar'},
                   {name: 'Lil Uzi Vert'},
                   {name: 'Future'},
                   {name: 'A$AP Rocky'}]) unless ArtistType.find_by(name: 'Future').present?

artist_types_id = ArtistType.pluck(:id)

puts '**** Created Type Artist List ****'
puts '\n\n'

puts 'Tracks creating ....'
puts '\n\n'

users_id = User.pluck(:id)
files  = ['artofcool.jpg', 'prince_ali.jpg', 'chillhop.jpg', 'tesk.jpg']
audios = ['art_of_cool.mp3', 'prince_ali.mp3', 'so_in_love.mp3', 'twrk.mp3']


500.times do |i|
  title       = Faker::Book.title
  description = Faker::Hipster.paragraph

  t = Track.create({
                     title:           title,
                     user_id:         users_id.sample,
                     image:           cover_file(files.sample),
                     audio:           audio_file(audios.sample),
                     artist_type_id:  artist_types_id.sample,
                     description:     description
                   })

  [1, 2, 3, 4].sample.times do
    genre     = Genre.find( genres.sample )
    subgenre  = Subgenre.find( subgenres.sample )

    t.genres    << genre    unless t.genres.include? genre
    t.subgenres << subgenre unless t.subgenres.include? subgenre
  end

  puts "#{i + 1} of 500: Created #{title} by #{t.user.name} with genres: #{ t.genres.map(&:name).join(', ') }"
  puts '/n/n'

  ( 1..users_id.size ).to_a.sample.times do
    Rating.create({
                    user_id: users_id.sample,
                    status: %i(like dislike indifferent).sample,
                    track_id: t.id
                  })
  end
end

puts 'Tracks created!'
puts '\n\n'
