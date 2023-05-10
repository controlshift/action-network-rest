# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::Forms do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:form_id) { 'e7b02e0a-a0a9-11e3-a2e9-12313d316c29' }
    let(:status) { 200 }
    let(:response_body) do
      {
        identifiers: [
          'action_network:adb951cb-51f9-420e-b7e6-de953195ec86'
        ],
        created_date: '2014-03-21T23:39:53Z',
        modified_date: '2014-03-25T15:26:45Z',
        title: 'Take our end of year survey',
        description: '<p>Let us know what you think!</p>',
        call_to_action: 'Let us know',
        browser_url: 'https://actionnetwork.org/forms/end-of-year-survey',
        featured_image_url: 'https://actionnetwork.org/images/survey.jpg',
        total_submissions: 6,
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
            href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86'
          },
          'osdi:submissions': {
            href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86/submissions'
          },
          'osdi:record_submission_helper': {
            href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86/submissions'
          },
          'osdi:creator': {
            href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
          },
          'action_network:embed': {
            href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86/embed'
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
      stub_actionnetwork_request("/forms/#{form_id}", method: :get)
        .to_return(status: status, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should retrieve form data' do
      form = subject.forms.get(form_id)
      expect(form.title).to eq 'Take our end of year survey'
      expect(form.total_submissions).to eq 6
      expect(form.action_network_id).to eq 'adb951cb-51f9-420e-b7e6-de953195ec86'
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
            href: 'https://actionnetwork.org/api/v2/forms?page=2'
          },
          self: {
            href: 'https://actionnetwork.org/api/v2/forms'
          },
          'osdi:forms': [
            {
              href: 'https://actionnetwork.org/api/v2/forms/65345d7d-cd24-466a-a698-4a7686ef684f'
            },
            {
              href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86'
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
          'osdi:forms': [
            {
              origin_system: 'FreeForms.com',
              identifiers: [
                'action_network:65345d7d-cd24-466a-a698-4a7686ef684f',
                'free_forms:1'
              ],
              created_date: '2014-03-25T14:40:07Z',
              modified_date: '2014-03-25T14:47:44Z',
              title: 'Tell your story',
              total_submissions: 25,
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
                  href: 'https://actionnetwork.org/api/v2/forms/65345d7d-cd24-466a-a698-4a7686ef684f'
                },
                'osdi:submissions': {
                  href: 'https://actionnetwork.org/api/v2/forms/65345d7d-cd24-466a-a698-4a7686ef684f/submissions'
                },
                'osdi:record_submission_helper': {
                  href: 'https://actionnetwork.org/api/v2/forms/65345d7d-cd24-466a-a698-4a7686ef684f/submissions'
                },
                'osdi:creator': {
                  href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
                },
                'action_network:embed': {
                  href: 'https://actionnetwork.org/api/v2/forms/65345d7d-cd24-466a-a698-4a7686ef684f/embed'
                }
              }
            },
            {
              identifiers: [
                'action_network:adb951cb-51f9-420e-b7e6-de953195ec86'
              ],
              created_date: '2014-03-21T23:39:53Z',
              modified_date: '2014-03-25T15:26:45Z',
              title: 'Take our end of year survey',
              description: '<p>Let us know what you think!</p>',
              call_to_action: 'Let us know',
              browser_url: 'https://actionnetwork.org/forms/end-of-year-survey',
              featured_image_url: 'https://actionnetwork.org/images/survey.jpg',
              total_submissions: 6,
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
                  href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86'
                },
                'osdi:submissions': {
                  href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86/submissions'
                },
                'osdi:record_submission_helper': {
                  href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86/submissions'
                },
                'osdi:creator': {
                  href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
                },
                'action_network:embed': {
                  href: 'https://actionnetwork.org/api/v2/forms/adb951cb-51f9-420e-b7e6-de953195ec86/embed'
                }
              }
            }
          ]
        }
      }.to_json
    end

    context 'requesting first page' do
      before :each do
        stub_actionnetwork_request('/forms/?page=1', method: :get)
          .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
      end

      it 'should retrieve first page when calling without page as argument' do
        forms = subject.forms.list

        expect(forms.count).to eq 2
        expect(forms.first.action_network_id).to eq '65345d7d-cd24-466a-a698-4a7686ef684f'
      end

      it 'should retrieve forms when calling with argument' do
        forms = subject.forms.list(page: 1)

        expect(forms.count).to eq 2
        expect(forms.first.action_network_id).to eq '65345d7d-cd24-466a-a698-4a7686ef684f'
      end
    end

    context 'requesting page 3 forms' do
      before :each do
        stub_actionnetwork_request('/forms/?page=3', method: :get)
          .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
      end

      it 'should retreive the forms data from page 3' do
        forms = subject.forms.list(page: 3)

        expect(forms.count).to eq 2
        expect(forms.first.action_network_id).to eq '65345d7d-cd24-466a-a698-4a7686ef684f'
      end
    end
  end

  describe '#create' do
    let(:form_data) do
      {
        title: 'My Free Form',
        origin_system: 'FreeForms.com'
      }
    end
    let(:request_body) { form_data.to_json }
    let(:response_body) do
      {
        origin_system: 'FreeForms.com',
        identifiers: [
          'action_network:d8fff9ec-78a4-4c3d-a724-d4bb751abfbb'
        ],
        created_date: '2014-03-26T21:52:07Z',
        modified_date: '2014-03-26T21:52:07Z',
        title: 'My Free Form',
        total_submissions: 0,
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
            href: 'https://actionnetwork.org/api/v2/forms/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb'
          },
          'osdi:submissions': {
            href: 'https://actionnetwork.org/api/v2/forms/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/submissions'
          },
          'osdi:record_submission_helper': {
            href: 'https://actionnetwork.org/api/v2/forms/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/submissions'
          },
          'osdi:creator': {
            href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
          },
          'action_network:embed': {
            href: 'https://actionnetwork.org/api/v2/forms/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/embed'
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
      stub_actionnetwork_request('/forms/', method: :post, body: request_body)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should POST form data' do
      form = subject.forms.create(form_data)

      expect(post_stub).to have_been_requested

      expect(form.title).to eq 'My Free Form'
    end
  end

  describe '#update' do
    let(:form_data) do
      {
        title: 'My Free Form With A New Name',
        description: 'This is my free form description'
      }
    end
    let(:form_id) { 'd8fff9ec-78a4-4c3d-a724-d4bb751abfbb' }
    let(:response_body) do
      {
        origin_system: 'FreeForms.com',
        identifiers: [
          'free_forms:1',
          'action_network:d8fff9ec-78a4-4c3d-a724-d4bb751abfbb'
        ],
        created_date: '2014-03-26T21:52:07Z',
        modified_date: '2014-03-26T21:54:28Z',
        title: 'My Free Form With A New Name',
        description: 'This is my free form description',
        total_submissions: 0,
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
            href: 'https://actionnetwork.org/api/v2/forms/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb'
          },
          'osdi:submissions': {
            href: 'https://actionnetwork.org/api/v2/forms/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/submissions'
          },
          'osdi:record_submission_helper': {
            href: 'https://actionnetwork.org/api/v2/forms/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/submissions'
          },
          'osdi:creator': {
            href: 'https://actionnetwork.org/api/v2/people/c945d6fe-929e-11e3-a2e9-12313d316c29'
          },
          'action_network:embed': {
            href: 'https://actionnetwork.org/api/v2/forms/d8fff9ec-78a4-4c3d-a724-d4bb751abfbb/embed'
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
      stub_actionnetwork_request("/forms/#{form_id}", method: :put, body: form_data)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should PUT form data' do
      updated_form = subject.forms.update(form_id, form_data)

      expect(put_stub).to have_been_requested

      expect(updated_form.title).to eq 'My Free Form With A New Name'
    end
  end
end
