FactoryGirl.define do
  factory :user do
  	username "Pekka"
  	password "Foobar1"
  	password_confirmation "Foobar1"
  end

  factory :user2, class: User do
    username "Pekka2"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
  	score 10
  end

  factory :rating2, class: Rating do
  	score 20
  end

  factory :rating3, class: Rating do
    score 34
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :brewery2, class: Brewery do
    name "ebin"
    year 2000
  end

  factory :style do
    name "Weizen"
    descr "lol"
  end

  factory :style2, class: Style do
    name "Lager"
    descr "best"
  end

  factory :beer do
    name "lol"
    brewery
    style
  end

  factory :beer2, class: Beer do
    name "anonymous"
    brewery
    style
  end

  factory :beer3, class: Beer do
    name "anon"
    brewery
    style
  end
end