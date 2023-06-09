# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    id { 3899631 }
    title { 'Ambipur air freshener plugin' }
    description { 'Device only but refills are available most places' }
    section { 'product' }
    updated_at { '2020-12-12T10:49:18.000Z' }
    created_at { '2020-12-12T10:49:18.000Z' }

    trait :out_of_date do
      created_at { Time.new(2017, 4, 15, 0, 0, 0, 0) }
      updated_at { Time.new(2017, 4, 15, 0, 0, 0, 0) }
    end

    trait :second do
      id { 3899634 }
      title { 'Epson Stylus Printer Cartridges' }
      description { '7 X T0714 (yellow)\n4 X T0711 (black)\n1 X E712 (cyan)\n4 X E713 / T0713 (magenta)\n\n' }
      updated_at { '2020-12-12T10:49:31.000Z' }
      created_at { '2020-12-12T10:49:31.000Z' }
    end
  end
end
