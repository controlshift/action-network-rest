# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::AdvocacyCampaigns do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:advocacy_campaign_id) { 'e7b02e0a-a0a9-11e3-a2e9-12313d316c29' }
    let(:status) { 200 }
    let(:response_body) do
      {
        identifiers: [
          'action_network:adb951cb-51f9-420e-b7e6-de953195ec86'
        ],
        created_date: '2014-03-21T23:39:53Z',
        modified_date: '2014-03-25T15:26:45Z',
        title: "Thank Acme's CEO for going green",
        description: '<p>Write a letter today!</p>',
        browser_url: 'https://actionnetwork.org/letters/thanks-acme',
        featured_image_url: 'https://actionnetwork.org/images/acme.jpg',
        targets: 'Acme CEO',
        type: 'email',
        total_outreaches: 6,
        'action_network:hidden': false,
        _embedded: {
          'osdi:creator': {
            given_name: 'John',
            family_name: 'Doe',
            identifiers: [
              'action_network:c945d6fe-929e-11e3-a2e9-12313d316c29'
            ],
            created_date: '2014-03-24T18:03:45Z',
            modified_date: '2014-03-25T15:00:22Z',
            email_addresses: [
              {
                primary: true,
                address: 'jdoe@mail.com',
                status: 'subscribed'
              }
            ],
            phone_numbers: [
              {
                primary: true,
                number: '12021234444',
                number_type: 'Mobile',
                status: 'subscribed'
              }
            ],
            postal_addresses: [
              {
                primary: true,
                address_lines: [
                  '1600 Pennsylvania Ave'
                ],
                locality: 'Washington',
                region: 'DC',
                postal_code: '20009',
                country: 'US',
                language: 'en',
                location: {
                  latitude: 32.934,
                  longitude: -72.0377,
                  accuracy: 'Approximate'
                }
              }
            ],
            languages_spoken: [
              'en'
            ],
            _links: {
              self: {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
              },
              'osdi:attendances': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/attendances'
              },
              'osdi:signatures': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/signatures'
              },
              'osdi:submissions': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/submissions'
              },
              'osdi:donations': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/donations'
              },
              'osdi:outreaches': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/outreaches'
              },
              'osdi:taggings': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/taggings'
              },
              curies: [
                {
                  name: 'osdi',
                  href: 'https://actionnetwork.org/docs/v2/{rel}',
                  templated: true
                },
                {
                  name: 'action_network',
                  href: 'https://actionnetwork.org/docs/v2/{rel}',
                  templated: true
                }
              ]
            }
          }
        },
        _links: {
          self: {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86'
          },
          'osdi:outreaches': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86/outreaches'
          },
          'osdi:record_outreach_helper': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86/outreaches'
          },
          'osdi:creator': {
            href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
          },
          'action_network:embed': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86/embed'
          },
          curies: [
            {
              name: 'osdi',
              href: 'https://actionnetwork.org/docs/v2/{rel}',
              templated: true
            },
            {
              name: 'action_network',
              href: 'https://actionnetwork.org/docs/v2/{rel}',
              templated: true
            }
          ]
        }
      }.to_json
    end

    before :each do
      stub_actionnetwork_request("/advocacy_campaigns/#{advocacy_campaign_id}", method: :get)
        .to_return(status: status, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should retrieve advocacy_campaign data' do
      advocacy_campaign = subject.advocacy_campaigns.get(advocacy_campaign_id)
      expect(advocacy_campaign.title).to eq 'Thank Acme\'s CEO for going green'
      expect(advocacy_campaign.total_outreaches).to eq 6
    end
  end

  describe '#list' do
    let(:response_body) do
      {
        total_pages: 10,
        per_page: 25,
        page: 1,
        total_records: 250,
        _links: {
          next: {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns?page=2'
          },
          self: {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns'
          },
          'osdi:advocacy_campaigns': [
            {
              href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/65345d7d-cd24-466a-a698-4a7686ef684f'
            },
            {
              href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86'
            }
          ],
          curies: [
            {
              name: 'osdi',
              href: 'https://actionnetwork.org/docs/v2/{rel}',
              templated: true
            },
            {
              name: 'action_network',
              href: 'https://actionnetwork.org/docs/v2/{rel}',
              templated: true
            }
          ]
        },
        _embedded: {
          'osdi:advocacy_campaigns': [
            {
              origin_system: 'FreeAdvocacy.com',
              identifiers: [
                'action_network:65345d7d-cd24-466a-a698-4a7686ef684f',
                'free_forms:1'
              ],
              created_date: '2014-03-25T14:40:07Z',
              modified_date: '2014-03-25T14:47:44Z',
              title: 'Tell your Senator to stop the bad thing!',
              targets: 'U.S. Senate',
              type: 'email',
              total_outreaches: 25,
              'action_network:hidden': false,
              _embedded: {
                'osdi:creator': {
                  given_name: 'John',
                  family_name: 'Doe',
                  identifiers: [
                    'action_network:c945d6fe-929e-11e3-a2e9-12313d316c29'
                  ],
                  created_date: '2014-03-24T18:03:45Z',
                  modified_date: '2014-03-25T15:00:22Z',
                  email_addresses: [
                    {
                      primary: true,
                      address: 'jdoe@mail.com',
                      status: 'subscribed'
                    }
                  ],
                  phone_numbers: [
                    {
                      primary: true,
                      number: '12021234444',
                      number_type: 'Mobile',
                      status: 'subscribed'
                    }
                  ],
                  postal_addresses: [
                    {
                      primary: true,
                      address_lines: [
                        '1600 Pennsylvania Ave'
                      ],
                      locality: 'Washington',
                      region: 'DC',
                      postal_code: '20009',
                      country: 'US',
                      language: 'en',
                      location: {
                        latitude: 32.935,
                        longitude: -73.1338,
                        accuracy: 'Approximate'
                      }
                    }
                  ],
                  languages_spoken: [
                    'en'
                  ],
                  _links: {
                    self: {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
                    },
                    'osdi:attendances': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/attendances'
                    },
                    'osdi:signatures': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/signatures'
                    },
                    'osdi:submissions': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/submissions'
                    },
                    'osdi:donations': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/donations'
                    },
                    'osdi:outreaches': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/outreaches'
                    },
                    'osdi:taggings': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/taggings'
                    }
                  }
                }
              },
              _links: {
                self: {
                  href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/65345d7d-cd24-466a-a698-4a7686ef684f'
                },
                'osdi:outreaches': {
                  href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/65345d7d-cd24-466a-a698-4a7686ef684f/outreaches'
                },
                'osdi:record_outreach_helper': {
                  href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/65345d7d-cd24-466a-a698-4a7686ef684f/outreaches'
                },
                'osdi:creator': {
                  href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
                },
                'action_network:embed': {
                  href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/65345d7d-cd24-466a-a698-4a7686ef684f/embed'
                }
              }
            },
            {
              identifiers: [
                'action_network:adb951cb-51f9-420e-b7e6-de953195ec86'
              ],
              created_date: '2014-03-21T23:39:53Z',
              modified_date: '2014-03-25T15:26:45Z',
              title: "Thank Acme's CEO for going green",
              description: '<p>Write a letter today!</p>',
              browser_url: 'https://actionnetwork.org/letters/thanks-acme',
              featured_image_url: 'https://actionnetwork.org/images/acme.jpg',
              targets: 'Acme CEO',
              type: 'email',
              total_outreaches: 6,
              'action_network:hidden': false,
              _embedded: {
                'osdi:creator': {
                  given_name: 'John',
                  family_name: 'Doe',
                  identifiers: [
                    'action_network:c945d6fe-929e-11e3-a2e9-12313d316c29'
                  ],
                  created_date: '2014-03-24T18:03:45Z',
                  modified_date: '2014-03-25T15:00:22Z',
                  email_addresses: [
                    {
                      primary: true,
                      address: 'jdoe@mail.com',
                      status: 'subscribed'
                    }
                  ],
                  phone_numbers: [
                    {
                      primary: true,
                      number: '12021234444',
                      number_type: 'Mobile',
                      status: 'subscribed'
                    }
                  ],
                  postal_addresses: [
                    {
                      primary: true,
                      address_lines: [
                        '1600 Pennsylvania Ave.'
                      ],
                      locality: 'Washington',
                      region: 'DC',
                      postal_code: '20009',
                      country: 'US',
                      language: 'en',
                      location: {
                        latitude: 32.934,
                        longitude: -74.5319,
                        accuracy: 'Approximate'
                      }
                    }
                  ],
                  languages_spoken: [
                    'en'
                  ],
                  _links: {
                    self: {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
                    },
                    'osdi:attendances': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/attendances'
                    },
                    'osdi:signatures': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/signatures'
                    },
                    'osdi:submissions': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/submissions'
                    },
                    'osdi:donations': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/donations'
                    },
                    'osdi:outreaches': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/outreaches'
                    },
                    'osdi:taggings': {
                      href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/taggings'
                    }
                  }
                }
              },
              _links: {
                self: {
                  href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86'
                },
                'osdi:outreaches': {
                  href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86/outreaches'
                },
                'osdi:record_outreach_helper': {
                  href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86/outreaches'
                },
                'osdi:creator': {
                  href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
                },
                'action_network:embed': {
                  href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/adb951cb-51f9-420e-b7e6-de953195ec86/embed'
                }
              }
            }
          ]
        }
      }.to_json
    end

    context 'requesting first page' do
      before :each do
        stub_actionnetwork_request('/advocacy_campaigns/?page=1', method: :get)
          .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
      end

      it 'should retrieve first page when callig with argument' do
        advocacy_campaigns = subject.advocacy_campaigns.list

        expect(advocacy_campaigns.count).to eq 2
        expect(advocacy_campaigns.first.action_network_id).to eq '65345d7d-cd24-466a-a698-4a7686ef684f'
      end

      it 'should retrieve advocacy_campaigns when calling with argument' do
        advocacy_campaigns = subject.advocacy_campaigns.list(page: 1)

        expect(advocacy_campaigns.count).to eq 2
        expect(advocacy_campaigns.first.action_network_id).to eq '65345d7d-cd24-466a-a698-4a7686ef684f'
      end
    end

    context 'requesting page 3 advocacy_campaigns' do
      before :each do
        stub_actionnetwork_request('/advocacy_campaigns/?page=3', method: :get)
          .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
      end

      it 'should retreive the advocacy_campaigns data from page 3' do
        advocacy_campaigns = subject.advocacy_campaigns.list(page: 3)

        expect(advocacy_campaigns.count).to eq 2
        expect(advocacy_campaigns.first.action_network_id).to eq '65345d7d-cd24-466a-a698-4a7686ef684f'
      end
    end
  end

  describe '#create' do
    let(:advocacy_campaign_data) do
      {
        identifiers: ['somesystem:123'],
        title: 'My Free Advocacy Campaign',
        origin_system: 'FreeAdvocacy.com',
        type: 'email'
      }
    end
    let(:request_body) { advocacy_campaign_data.to_json }
    let(:response_body) do
      {
        origin_system: 'FreeAdvocacy.com',
        identifiers: [
          'action_network:d8fff9ec-78a4-4c3d-a724-d4bb751abfbb',
          'somesystem:123'
        ],
        created_date: '2014-03-26T21:52:07Z',
        modified_date: '2014-03-26T21:52:07Z',
        title: 'My Free Advocacy Campaign',
        type: 'email',
        total_outreaches: 0,
        'action_network:hidden': false,
        _embedded: {
          'osdi:creator': {
            given_name: 'John',
            family_name: 'Doe',
            identifiers: [
              'action_network:c945d6fe-929e-11e3-a2e9-12313d316c29'
            ],
            created_date: '2014-03-24T18:03:45Z',
            modified_date: '2014-03-25T15:00:22Z',
            email_addresses: [
              {
                primary: true,
                address: 'jdoe@mail.com',
                status: 'subscribed'
              }
            ],
            phone_numbers: [
              {
                primary: true,
                number: '12021234444',
                number_type: 'Mobile',
                status: 'subscribed'
              }
            ],
            postal_addresses: [
              {
                primary: true,
                address_lines: [
                  '1600 Pennsylvania Ave'
                ],
                locality: 'Washington',
                region: 'DC',
                postal_code: '20009',
                country: 'US',
                language: 'en',
                location: {
                  latitude: 32.935,
                  longitude: -56.0377,
                  accuracy: 'Approximate'
                }
              }
            ],
            languages_spoken: [
              'en'
            ],
            _links: {
              self: {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
              },
              'osdi:attendances': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/attendances'
              },
              'osdi:signatures': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/signatures'
              },
              'osdi:submissions': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/submissions'
              },
              'osdi:donations': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/donations'
              },
              'osdi:outreaches': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/outreaches'
              },
              'osdi:taggings': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/taggings'
              },
              curies: [
                {
                  name: 'osdi',
                  href: 'https://actionnetwork.org/docs/v2/{rel}',
                  templated: true
                },
                {
                  name: 'action_network',
                  href: 'https://actionnetwork.org/docs/v2/{rel}',
                  templated: true
                }
              ]
            }
          }
        },
        _links: {
          self: {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb'
          },
          'osdi:outreaches': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/outreaches'
          },
          'osdi:record_outreach_helper': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/outreaches'
          },
          'osdi:creator': {
            href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
          },
          'action_network:embed': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/embed'
          },
          curies: [
            {
              name: 'osdi',
              href: 'https://actionnetwork.org/docs/v2/{rel}',
              templated: true
            },
            {
              name: 'action_network',
              href: 'https://actionnetwork.org/docs/v2/{rel}',
              templated: true
            }
          ]
        }
      }.to_json
    end
    let!(:post_stub) do
      stub_actionnetwork_request('/advocacy_campaigns/', method: :post, body: request_body)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should POST advocacy_campaign data' do
      advocacy_campaign = subject.advocacy_campaigns.create(advocacy_campaign_data)

      expect(post_stub).to have_been_requested

      expect(advocacy_campaign.identifiers).to contain_exactly('action_network:d8fff9ec-78a4-4c3d-a724-d4bb751abfbb',
                                                               'somesystem:123')
      expect(advocacy_campaign.action_network_id).to eq 'd8fff9ec-78a4-4c3d-a724-d4bb751abfbb'
    end
  end

  describe '#update' do
    let(:advocacy_campaign_data) do
      {
        identifiers: ['somesystem:123'],
        title: 'My Free Advocacy Campaign With A New Name',
        description: 'This is my free advocacy campaign description'
      }
    end
    let(:advocacy_campaign_id) { 'd8fff9ec-78a4-4c3d-a724-d4bb751abfbb' }
    let(:response_body) do
      {
        origin_system: 'FreeAdvocacy.com',
        identifiers: [
          'action_network:d8fff9ec-78a4-4c3d-a724-d4bb751abfbb',
          'somesystem:123'
        ],
        created_date: '2014-03-26T21:52:07Z',
        modified_date: '2014-03-26T21:54:28Z',
        title: 'My Free Advocacy Campaign With A New Name',
        description: 'This is my free advocacy campaign description',
        type: 'email',
        total_outreaches: 0,
        'action_network:hidden': false,
        _embedded: {
          'osdi:creator': {
            given_name: 'John',
            family_name: 'Doe',
            identifiers: [
              'action_network:c945d6fe-929e-11e3-a2e9-12313d316c29'
            ],
            created_date: '2014-03-24T18:03:45Z',
            modified_date: '2014-03-25T15:00:22Z',
            email_addresses: [
              {
                primary: true,
                address: 'jdoe@mail.com',
                status: 'subscribed'
              }
            ],
            phone_numbers: [
              {
                primary: true,
                number: '12021234444',
                number_type: 'Mobile',
                status: 'subscribed'
              }
            ],
            postal_addresses: [
              {
                primary: true,
                address_lines: [
                  '1600 Pennsylvania Ave'
                ],
                locality: 'Washington',
                region: 'DC',
                postal_code: '20009',
                country: 'US',
                language: 'en',
                location: {
                  latitude: 32.416,
                  longitude: -75.0672,
                  accuracy: 'Approximate'
                }
              }
            ],
            languages_spoken: [
              'en'
            ],
            _links: {
              self: {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
              },
              'osdi:attendances': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/attendances'
              },
              'osdi:signatures': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/signatures'
              },
              'osdi:submissions': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/submissions'
              },
              'osdi:donations': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/donations'
              },
              'osdi:outreaches': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/outreaches'
              },
              'osdi:taggings': {
                href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29/taggings'
              },
              curies: [
                {
                  name: 'osdi',
                  href: 'https://actionnetwork.org/docs/v2/{rel}',
                  templated: true
                },
                {
                  name: 'action_network',
                  href: 'https://actionnetwork.org/docs/v2/{rel}',
                  templated: true
                }
              ]
            }
          }
        },
        _links: {
          self: {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb'
          },
          'osdi:outreaches': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/outreaches'
          },
          'osdi:record_outreach_helper': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/outreaches'
          },
          'osdi:creator': {
            href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
          },
          'action_network:embed': {
            href: 'https://actionnetwork.org/api/v2/advocacy_campaigns/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/embed'
          },
          curies: [
            {
              name: 'osdi',
              href: 'https://actionnetwork.org/docs/v2/{rel}',
              templated: true
            },
            {
              name: 'action_network',
              href: 'https://actionnetwork.org/docs/v2/{rel}',
              templated: true
            }
          ]
        }
      }.to_json
    end
    let!(:put_stub) do
      stub_actionnetwork_request("/advocacy_campaigns/#{advocacy_campaign_id}",
                                 method: :put,
                                 body: advocacy_campaign_data)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should PUT advocacy_campaign data' do
      updated_advocacy_campaign = subject.advocacy_campaigns.update(advocacy_campaign_id, advocacy_campaign_data)

      expect(put_stub).to have_been_requested

      expect(updated_advocacy_campaign.identifiers).to(
        contain_exactly('action_network:d8fff9ec-78a4-4c3d-a724-d4bb751abfbb',
                        'somesystem:123')
      )
    end
  end
end
