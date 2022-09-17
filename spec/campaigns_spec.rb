# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::EventCampaigns do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:campaign_id) { 'e7b02e0a-a0a9-11e3-a2e9-12313d316c29' }
    let(:status) { 200 }
    let(:response_body) do
      {
        identifiers: [
          "action_network:#{campaign_id}"
        ],
        origin_system: 'Action Network',
        created_date: '2013-10-02T14:21:32Z',
        modified_date: '2013-10-02T14:22:06Z',
        title: 'Join our week of actions!',
        description: '<p>Our week of action is here -- click the links on the right to join in!</p>',
        browser_url: 'https://actionnetwork.org/campaigns/join-our-week-of-action',
        featured_image_url: 'https://actionnetwork.org/images/week-of-action.jpg',
        'action_network:hidden' => false,
        'action_network:sponsor' => {
          title: 'Progressive Action Now',
          browser_url: 'https://actionnetwork.org/groups/progressive-action-now'
        },
        actions: [
          {
            title: 'Sign the petition',
            browser_url: 'https://actionnetwork.org/petitions/sign-the-petition'
          },
          {
            title: 'Attend the rally',
            browser_url: 'https://actionnetwork.org/events/attend-the-rally'
          }
        ],
        _links: {
          self: {
            href: 'https://actionnetwork.org/api/v2/campaigns/e7b02e0a-a0a9-11e3-a2e9-12313d316c29'
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
      stub_actionnetwork_request("/campaigns/#{campaign_id}", method: :get)
        .to_return(status: status, body: response_body)
    end

    it 'should retrieve campaign data' do
      campaign = subject.campaigns.get(campaign_id)
      expect(campaign.title).to eq 'Join our week of actions!'
      expect(campaign.actions.first.title).to eq 'Sign the petition'
    end
  end

  describe '#list' do
    let(:response_body) do
      {
        total_pages: 2,
        per_page: 25,
        page: 1,
        total_records: 30,
        _links: {
          next: {
            href: 'https://actionnetwork.org/api/v2/campaigns?page=2'
          },
          self: {
            href: 'https://actionnetwork.org/api/v2/campaigns'
          },
          'action_network:campaigns': [
            {
              href: 'https://actionnetwork.org/api/v2/campaigns/e7b02e0a-a0a9-11e3-a2e9-12313d316c29'
            },
            {
              href: 'https://actionnetwork.org/api/v2/campaigns/e7b0287e-a0a9-11e3-a2e9-12313d316c29'
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
          'action_network:campaigns': [
            {
              identifiers: [
                'action_network:e7b02e0a-a0a9-11e3-a2e9-12313d316c29'
              ],
              origin_system: 'Action Network',
              created_date: '2013-10-02T14:21:32Z',
              modified_date: '2013-10-02T14:22:06Z',
              title: 'Join our week of actions!',
              description: '<p>Our week of action is here -- click the links on the right to join in!</p>',
              browser_url: 'https://actionnetwork.org/campaigns/join-our-week-of-action',
              featured_image_url: 'https://actionnetwork.org/images/week-of-action.jpg',
              'action_network:hidden': false,
              'action_network:sponsor': {
                title: 'Progressive Action Now',
                browser_url: 'https://actionnetwork.org/groups/progressive-action-now'
              },
              actions: [
                {
                  title: 'Sign the petition',
                  browser_url: 'https://actionnetwork.org/petitions/sign-the-petition'
                },
                {
                  title: 'Attend the rally',
                  browser_url: 'https://actionnetwork.org/events/attend-the-rally'
                }
              ],
              _links: {
                self: {
                  href: 'https://actionnetwork.org/api/v2/campaigns/e7b02e0a-a0a9-11e3-a2e9-12313d316c29'
                }
              }
            },
            {
              identifiers: [
                'action_network:e7b0287e-a0a9-11e3-a2e9-12313d316c29'
              ],
              origin_system: 'Action Network',
              created_date: '2013-09-30T15:55:44Z',
              modified_date: '2014-01-16T19:07:00Z',
              title: 'Welcome to our Action Center',
              description: '<p>Welcome to our Action Center. Take action on the right.</p>',
              browser_url: 'https://actionnetwork.org/campaigns/welcome-to-our-action-center',
              'action_network:sponsor': {
                title: 'Progressive Action Now',
                browser_url: 'https://actionnetwork.org/groups/progressive-action-now'
              },
              actions: [
                {
                  title: 'Sign up for email updates',
                  browser_url: 'https://actionnetwork.org/forms/sign-up-for-email-updates'
                },
                {
                  title: 'Take our survey',
                  browser_url: 'https://actionnetwork.org/forms/take-our-survey'
                }
              ],
              _links: {
                self: {
                  href: 'https://actionnetwork.org/api/v2/campaigns/e7b0287e-a0a9-11e3-a2e9-12313d316c29'
                }
              }
            }
          ]
        }
      }.to_json
    end

    context 'requesting first page' do
      before :each do
        stub_actionnetwork_request('/campaigns/?page=1', method: :get)
          .to_return(status: 200, body: response_body)
      end

      it 'should retrieve first page when callig with argument' do
        campaigns = subject.campaigns.list

        expect(campaigns.count).to eq 2
        expect(campaigns.first.action_network_id).to eq 'e7b02e0a-a0a9-11e3-a2e9-12313d316c29'
      end

      it 'should retrieve campaigns when calling with argument' do
        campaigns = subject.campaigns.list(page: 1)

        expect(campaigns.count).to eq 2
        expect(campaigns.first.action_network_id).to eq 'e7b02e0a-a0a9-11e3-a2e9-12313d316c29'
      end
    end

    context 'requesting page 3 campaigns' do
      before :each do
        stub_actionnetwork_request('/campaigns/?page=3', method: :get)
          .to_return(status: 200, body: response_body)
      end

      it 'should retreive the campaigns data from page 3' do
        campaigns = subject.campaigns.list(page: 3)

        expect(campaigns.count).to eq 2
        expect(campaigns.first.action_network_id).to eq 'e7b02e0a-a0a9-11e3-a2e9-12313d316c29'
      end
    end
  end
end
