# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Reader.Repo.insert!(%Reader.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Reader.Repo
alias Reader.Feed.Category

arts =
  Category.changeset(%Category{}, %{
    title: "Arts",
    slug: Category.create_slug("Arts"),
    itunes_id: 1301
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Food",
     slug: Category.create_slug("Food"),
     itunes_id: 1306,
     parent_id: arts.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
    title: "Literature",
    slug: Category.create_slug("Literature"),
    itunes_id: 1401,
    parent_id: arts.id
  })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Design",
     slug: Category.create_slug("Design"),
     itunes_id: 1402,
     parent_id: arts.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Performing Arts",
     slug: Category.create_slug("Performing Arts"),
     itunes_id: 1405,
     parent_id: arts.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Visual Arts",
     slug: Category.create_slug("Visual Arts"),
     itunes_id: 1406,
     parent_id: arts.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Fashion & Beauty",
     slug: Category.create_slug("Fashion & Beauty"),
     itunes_id: 1459,
     parent_id: arts.id
   })
|> Repo.insert!

comedy =
  Category.changeset(%Category{}, %{
    title: "Comedy",
    slug: Category.create_slug("Comedy"),
    itunes_id: 1303
  })
  |> Repo.insert!

education =
  Category.changeset(%Category{}, %{
    title: "Education",
    slug: Category.create_slug("Education"),
    itunes_id: 1304
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "K-12",
     slug: Category.create_slug("K-12"),
     itunes_id: 1415,
     parent_id: education.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Higher Education",
     slug: Category.create_slug("Higher Education"),
     itunes_id: 1416,
     parent_id: education.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Educational Technology",
     slug: Category.create_slug("Educational Technology"),
     itunes_id: 1468,
     parent_id: education.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Language Courses",
     slug: Category.create_slug("Language Courses"),
     itunes_id: 1469,
     parent_id: education.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Training",
     slug: Category.create_slug("Training"),
     itunes_id: 1470,
     parent_id: education.id
   })
|> Repo.insert!

kids_fam =
  Category.changeset(%Category{}, %{
    title: "Kids & Family",
    slug: Category.create_slug("Kids & Family"),
    itunes_id: 1305
  })
  |> Repo.insert!

health =
  Category.changeset(%Category{}, %{
    title: "Health",
    slug: Category.create_slug("Health"),
    itunes_id: 1307
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Fitness & Nutrition",
     slug: Category.create_slug("Fitness & Nutrition"),
     itunes_id: 1417,
     parent_id: health.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Self-Help",
     slug: Category.create_slug("Self-Help"),
     itunes_id: 1420,
     parent_id: health.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Sexuality",
     slug: Category.create_slug("Sexuality"),
     itunes_id: 1421,
     parent_id: health.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Alternative Health",
     slug: Category.create_slug("Alternative Health"),
     itunes_id: 1481,
     parent_id: health.id
   })
|> Repo.insert!

tv_film =
  Category.changeset(%Category{}, %{
    title: "TV & Film",
    slug: Category.create_slug("TV & Film"),
    itunes_id: 1309
  })
  |> Repo.insert!

music =
  Category.changeset(%Category{}, %{
    title: "Music",
    slug: Category.create_slug("Music"),
    itunes_id: 1310
  })
  |> Repo.insert!

news_politics =
  Category.changeset(%Category{}, %{
    title: "News & Politics",
    slug: Category.create_slug("News & Politics"),
    itunes_id: 1311
  })
  |> Repo.insert!

religion =
  Category.changeset(%Category{}, %{
    title: "Religion & Spirituality",
    slug: Category.create_slug("Religion & Spirituality"),
    itunes_id: 1314
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Buddhism",
     slug: Category.create_slug("Buddhism"),
     itunes_id: 1438,
     parent_id: religion.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Christianity",
     slug: Category.create_slug("Christianity"),
     itunes_id: 1439,
     parent_id: religion.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Islam",
     slug: Category.create_slug("Islam"),
     itunes_id: 1440,
     parent_id: religion.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Judaism",
     slug: Category.create_slug("Judaism"),
     itunes_id: 1441,
     parent_id: religion.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Spirituality",
     slug: Category.create_slug("Spirituality"),
     itunes_id: 1444,
     parent_id: religion.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Hinduism",
     slug: Category.create_slug("Hinduism"),
     itunes_id: 1463,
     parent_id: religion.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Other",
     slug: Category.create_slug("Other"),
     itunes_id: 1464,
     parent_id: religion.id
   })
|> Repo.insert!

science =
  Category.changeset(%Category{}, %{
    title: "Science & Medicine",
    slug: Category.create_slug("Science & Medicine"),
    itunes_id: 1315
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Natural Sciences",
     slug: Category.create_slug("Natural Sciences"),
     itunes_id: 1477,
     parent_id: science.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Medicine",
     slug: Category.create_slug("Medicine"),
     itunes_id: 1478,
     parent_id: science.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Social Sciences",
     slug: Category.create_slug("Social Sciences"),
     itunes_id: 1479,
     parent_id: science.id
   })
|> Repo.insert!

sports =
  Category.changeset(%Category{}, %{
    title: "Sports & Recreation",
    slug: Category.create_slug("Sports & Recreation"),
    itunes_id: 1316
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Outdoor",
     slug: Category.create_slug("Outdoor"),
     itunes_id: 1456,
     parent_id: sports.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Professional",
     slug: Category.create_slug("Professional"),
     itunes_id: 1465,
     parent_id: sports.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "College & High School",
     slug: Category.create_slug("College & High School"),
     itunes_id: 1466,
     parent_id: sports.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Amateur",
     slug: Category.create_slug("Amateur"),
     itunes_id: 1467,
     parent_id: sports.id
   })
|> Repo.insert!

tech =
  Category.changeset(%Category{}, %{
    title: "Technology",
    slug: Category.create_slug("Technology"),
    itunes_id: 1318
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Gadgets",
     slug: Category.create_slug("Gadgets"),
     itunes_id: 1446,
     parent_id: tech.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Tech News",
     slug: Category.create_slug("Tech News"),
     itunes_id: 1448,
     parent_id: tech.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Podcasting",
     slug: Category.create_slug("Podcasting"),
     itunes_id: 1450,
     parent_id: tech.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Software How-To",
     slug: Category.create_slug("Software How-To"),
     itunes_id: 1480,
     parent_id: tech.id
   })
|> Repo.insert!

business =
  Category.changeset(%Category{}, %{
    title: "Business",
    slug: Category.create_slug("Business"),
    itunes_id: 1321
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Careers",
     slug: Category.create_slug("Careers"),
     itunes_id: 1410,
     parent_id: business.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Investing",
     slug: Category.create_slug("Investing"),
     itunes_id: 1412,
     parent_id: business.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Management & Marketing",
     slug: Category.create_slug("Management & Marketing"),
     itunes_id: 1413,
     parent_id: business.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Business News",
     slug: Category.create_slug("Business News"),
     itunes_id: 1471,
     parent_id: business.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Shopping",
     slug: Category.create_slug("Shopping"),
     itunes_id: 1472,
     parent_id: business.id
   })
|> Repo.insert!

games =
  Category.changeset(%Category{}, %{
    title: "Games & Hobbies",
    slug: Category.create_slug("Games & Hobbies"),
    itunes_id: 1323
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Video Games",
     slug: Category.create_slug("Video Games"),
     itunes_id: 1404,
     parent_id: games.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Automotive",
     slug: Category.create_slug("Automotive"),
     itunes_id: 1454,
     parent_id: games.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Aviation",
     slug: Category.create_slug("Aviation"),
     itunes_id: 1455,
     parent_id: games.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Hobbies",
     slug: Category.create_slug("Hobbies"),
     itunes_id: 1460,
     parent_id: games.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Other Games",
     slug: Category.create_slug("Other Games"),
     itunes_id: 1461,
     parent_id: games.id
   })
|> Repo.insert!

society =
  Category.changeset(%Category{}, %{
    title: "Society & Culture",
    slug: Category.create_slug("Society & Culture"),
    itunes_id: 1324
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Personal Journals",
     slug: Category.create_slug("Personal Journals"),
     itunes_id: 1302,
     parent_id: society.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Places & Travel",
     slug: Category.create_slug("Places & Travel"),
     itunes_id: 1320,
     parent_id: society.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Philosophy",
     slug: Category.create_slug("Philosophy"),
     itunes_id: 1443,
     parent_id: society.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "History",
     slug: Category.create_slug("History"),
     itunes_id: 1462,
     parent_id: society.id
   })
|> Repo.insert!

gov =
  Category.changeset(%Category{}, %{
    title: "Government & Organizations",
    slug: Category.create_slug("Government & Organizations"),
    itunes_id: 1325
  })
  |> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "National",
     slug: Category.create_slug("National"),
     itunes_id: 1473,
     parent_id: gov.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Regional",
     slug: Category.create_slug("Regional"),
     itunes_id: 1474,
     parent_id: gov.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Local",
     slug: Category.create_slug("Local"),
     itunes_id: 1475,
     parent_id: gov.id
   })
|> Repo.insert!

%Category{}
|> Category.changeset(%{
     title: "Non-Profit",
     slug: Category.create_slug("Non-Profit"),
     itunes_id: 1476,
     parent_id: gov.id
   })
|> Repo.insert!
