require "csv"

# Some clean up
Movie.delete_all
ProductionCompany.delete_all

filename = Rails.root.join("db/top_movies.csv") # build out the absolute path to file
puts "Loading Movies from the CSV file: #{filename}"

csv_data = File.read(filename)
movies = CSV.parse(csv_data, headers: true, encoding: "utf-8")

movies.each do |m|
  # puts m["original_title"]
  # production_company = ProductionCompany.create(name: m["production_company"]) --> Creates an issue with companies not being unique

  # Fix duplication problem with find_or_create_by
  production_company = ProductionCompany.find_or_create_by(name: m["production_company"])

  if production_company && production_company.valid?
    # created the movie
    movie = production_company.movies.create(
      title:        m["original_title"],
      year:         m["year"],
      duration:     m["duration"],
      description:  m["description"],
      average_vote: m["avg_vote"]
    )
    puts "Invalid Movie: #{m['original_title']}" unless movie&.valid?
  else
    puts "invalid production company #{m['production_company']} for movie #{m['original_title']}"
  end
end

puts "Created #{ProductionCompany.count} Production Companies"
puts "Created #{Movie.count} Movies"
