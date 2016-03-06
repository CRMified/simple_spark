# SimpleSpark

[![Build Status](https://travis-ci.org/leadmachineapp/simple_spark.png?branch=master)](https://travis-ci.org/leadmachineapp/simple_spark)

This gem is an alternative to the [official Ruby gem](https://github.com/SparkPost/ruby-sparkpost) provided by [SparkPost](http://www.sparkpost.com)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_spark'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install simple_spark
```
## Usage

### Why?

The official gem is somewhat lacking in functionality, though with the demise of Mandrill it seems SparkPost may have decided to restart development on it.

But, not being in a mood to wait, and as we would have to write wrappers around all the functions we would need anyway, it seemed much easier to write the wrapper as a gem and allow others to use it too.

The official gem currently only supports the send_message (create) method of /transmissions and it does it with a limited argument set. As it uses method parameters for each of the arguments it supports, it is not possible to use all the functionality the SparkPost API has. This gem will allow passing the parameters as hashes, allowing you to directly copy an API example into code and take full advantage of all the API functions.

### Status

It's day one, and it's a day one project.


## Endpoints

### Creating a Client

First you need to ensure you are requiring the library

```ruby
require 'simple_spark'
```

The simplest version of the client is to just provide your [API key from SparkPost](https://app.sparkpost.com/account/credentials)

```ruby
client = SimpleSpark::Client.new('your_api_key')
```

You can also use ENV vars to configure the key, setting ENV['SPARKPOST_API_KEY'] will allow you to just use

```ruby
client = SimpleSpark::Client.new
```

You can also override the other options if you need to in advanced scenarios, the full signature is

```ruby
client = SimpleSpark::Client.new('your_api_key', api_host = 'https://api.sparkpost.com', base_path = '/api/v1/' , debug = false)
```

Setting debug to true will cause [Excon](https://github.com/excon/excon) to output full debug information to the log, to default the other values and just set debug, send nil values

```ruby
client = SimpleSpark::Client.new(nil, nil, nil, true)
```

### Transmissions

#### List

List all Transmissions

When messages are sent the Transmission will be deleted, so this will only return transmissions that are about to be sent or are scheduled for the future

```ruby
client.transmissions.list
```

<a href="https://developers.sparkpost.com/api/#/reference/transmissions/list" target="_blank">see SparkPost API Documentation</a>

#### Create

Create a new Transmission

```ruby
properties = {
  options: { open_tracking: true, click_tracking: true },
  campaign_id: 'christmas_campaign',
  return_path: 'bounces-christmas-campaign@sp.neekme.com',
  metadata: {user_type: 'students'},
  substitution_data: { sender: 'Big Store Team' },
  recipients:  [
    { address: { email: 'yourcustomer@theirdomain.com', name: 'Your Customer' },
      tags: ['greeting', 'sales'],
      metadata: { place: 'Earth' }, substitution_data: { address: '123 Their Road' } }
  ],
  content:
  { from: { name: 'Your Name', email: 'you@yourdomain.com' },
    subject: 'I am a test email',
    reply_to: 'Sales <sales@yourdomain.com>',
    headers: { 'X-Customer-CampaignID' => 'christmas_campaign' },
    text: 'Hi from {{sender}} ... this is a test, and here is your address {{address}}',
    html: '<p>Hi from {{sender}}</p<p>This is a test</p>'
  }
}

client.transmissions.create(properties)
```

To send attachments, they need to be Base64 encoded

```ruby
properties = {
  recipients:  [{ address: { email: 'yourcustomer@theirdomain.com', name: 'Your Customer' }],
  content:
  { from: { name: 'Your Name', email: 'you@yourdomain.com' },
    subject: 'I am a test email',
    html: '<p>Hi from {{sender}}</p<p>This is a test</p>',
    attachments: [{ name: "attachment.txt", type: "text/plain", data: attachment }]
  }
}

# load your file contents first, then use Base64 to encode them
encoded_attachment = Base64.encode64('My file contents')
properties[:content][:attachments] = [{ name: "attachment.txt", type: "text/plain", data: encoded_attachment }]

client.transmissions.create(properties)
```

<a href="https://developers.sparkpost.com/api/#/reference/transmissions/create" target="_blank">see SparkPost API Documentation</a>

### Messsage Events

#### Samples

List an example of the event data that will be included in a response from the Message Events search endpoint

```ruby
client.message_events.samples
```

To limit to just some events

```ruby
client.message_events.samples('bounce')
```

<a href="https://developers.sparkpost.com/api/#/reference/message-events/events-samples" target="_blank">see SparkPost API Documentation</a>

#### Search

Perform a filtered search for message event data. The response is sorted by descending timestamp. For full options you should consult the SparkPost API documentation

```ruby
client.message_events.search(campaign_ids: 'christmas-campaign, summer-campaign')
```

<a href="https://developers.sparkpost.com/api/#/reference/message-events/events-samples" target="_blank">see SparkPost API Documentation</a>

### Webhooks

#### List

List all Webhooks, optionally providing a timezone property

```ruby
client.webhooks.list('America/New_York')
```

<a href="https://developers.sparkpost.com/api/#/reference/webhooks/list" target="_blank">see SparkPost API Documentation</a>

#### Create

Create a new Webhook

```ruby
client.webhooks.create(values)
```

<a href="https://developers.sparkpost.com/api/#/reference/webhooks/create" target="_blank">see SparkPost API Documentation</a>

#### Retrieve

Retrieves a Webhook

```ruby
client.webhooks.retrieve(webhook_id)
```

<a href="https://developers.sparkpost.com/api/#/reference/webhooks/retrieve" target="_blank">see SparkPost API Documentation</a>

#### Update

Updates a Webhook with new values

```ruby
properties = { "name" => "New name" }
client.webhooks.update(webhook_id, properties)
```

<a href="https://developers.sparkpost.com/api/#/reference/webhooks/update-and-delete" target="_blank">see SparkPost API Documentation</a>

#### Validate

Validates a Webhook by sending an example message event batch from the Webhooks API to the target URL

```ruby
client.webhooks.validate(webhook_id)
```

<a href="https://developers.sparkpost.com/api/#/reference/webhooks/validate" target="_blank">see SparkPost API Documentation</a>

#### Batch Status

Retrieve the Batch Status Information for a Webhook

```ruby
client.webhooks.batch_status(webhook_id)
```

<a href="https://developers.sparkpost.com/api/#/reference/webhooks/batch-status" target="_blank">see SparkPost API Documentation</a>

#### Samples

List an example of the event data that will be sent from a webhook

```ruby
client.webhooks.samples
```

To limit to just some events

```ruby
client.webhooks.samples('bounce')
```

<a href="https://developers.sparkpost.com/api/#/reference/message-events/events-samples" target="_blank">see SparkPost API Documentation</a>

### Sending Domains

#### List

List all Sending Domains

```ruby
client.sending_domains.list
```

<a href="https://developers.sparkpost.com/api/#/reference/sending-domains/create-and-list" target="_blank">see SparkPost API Documentation</a>

#### Create

Create a new Sending Domain

```ruby
client.sending_domains.create('mail.mydomain.com')
```

<a href="https://developers.sparkpost.com/api/#/reference/sending-domains/create-and-list" target="_blank">see SparkPost API Documentation</a>

#### Retrieve

Retrieves a Sending Template by its domain name

```ruby
client.sending_domains.retrieve('mail.mydomain.com')
```

<a href="https://developers.sparkpost.com/api/#/reference/sending-domains/retrieve-update-and-delete" target="_blank">see SparkPost API Documentation</a>

#### Update

Updates a Sending Domain with new values

```ruby
properties = { "tracking_domain" => "new.tracking.domain" }
client.sending_domains.update('mail.mydomain.com', properties)
```

<a href="https://developers.sparkpost.com/api/#/reference/sending-domains/retrieve-update-and-delete" target="_blank">see SparkPost API Documentation</a>

#### Verify

Forces verification of a Sending Domain.

Including the fields "dkim_verify" and/or "spf_verify" in the request initiates a check against the associated DNS record
type for the specified sending domain.Including the fields "postmaster_at_verify" and/or "abuse_at_verify" in the request
results in an email sent to the specified sending domain's postmaster@ and/or abuse@ mailbox where a verification link can
be clicked. Including the fields "postmaster_at_token" and/or "abuse_at_token" in the request initiates a check of the provided
token(s) against the stored token(s) for the specified sending domain.

```ruby
properties = { "dkim_verify": true, "spf_verify": true }
client.sending_domains.retrieve('mail.mydomain.com', properties)
```

<a href="https://developers.sparkpost.com/api/#/reference/sending-domains/verify" target="_blank">see SparkPost API Documentation</a>

#### Delete

Deletes a Sending Domain permanently

```ruby
client.sending_domains.delete('mail.mydomain.com')
```

<a href="https://developers.sparkpost.com/api/#/reference/sending-domains/retrieve-update-and-delete" target="_blank">see SparkPost API Documentation</a>

### Inbound Domains

#### List

List all Inbound Domains

```ruby
client.inbound_domains.list
```

<a href="https://developers.sparkpost.com/api/#/reference/inbound-domains/create-and-list" target="_blank">see SparkPost API Documentation</a>

#### Create

Create a new Inbound Domain

```ruby
client.inbound_domains.create('mail.mydomain.com')
```

<a href="https://developers.sparkpost.com/api/#/reference/inbound-domains/create-and-list" target="_blank">see SparkPost API Documentation</a>

#### Retrieve

Retrieves an Inbound Template by its domain name

```ruby
client.inbound_domains.retrieve('mail.mydomain.com')
```

<a href="https://developers.sparkpost.com/api/#/reference/inbound-domains/retrieve-and-delete" target="_blank">see SparkPost API Documentation</a>

#### Delete

Deletes an Inbound Domain permanently

```ruby
client.inbound_domains.delete('mail.mydomain.com')
```

<a href="https://developers.sparkpost.com/api/#/reference/inbound-domains/retrieve-and-delete" target="_blank">see SparkPost API Documentation</a>

### Templates

#### List

List all templates

```ruby
client.templates.list
```

<a href="https://developers.sparkpost.com/api/#/reference/templates/create-and-list" target="_blank">see SparkPost API Documentation</a>

#### Create

Create a new Template

```ruby
properties = {  "name" => "Summer Sale!", "content"=> { "from" => "marketing@yourdomain.com",   "subject"=> "Summer deals",  "html"=> "<b>Check out these deals!</b>"}}
client.templates.create(properties)
```

<a href="https://developers.sparkpost.com/api/#/reference/templates/create-and-list" target="_blank">see SparkPost API Documentation</a>

#### Retrieve

Retrieves a Template by its ID

```ruby
draft = nil
client.templates.retrieve(yourtemplateid, draft)
```

<a href="https://developers.sparkpost.com/api/#/reference/templates/retrieve" target="_blank">see SparkPost API Documentation</a>

#### Update

Updates a Template with new values

```ruby
properties = { "name" => "Sorry, the Winter Sale!" }}
update_published = false
client.templates.update(yourtemplateid, properties, update_published)
```

<a href="https://developers.sparkpost.com/api/#/reference/templates/update" target="_blank">see SparkPost API Documentation</a>

#### Preview

Merges the template with the Substitution data and returns the result

```ruby
properties = { substitution_data: { name: 'Mr test User' } }
draft = nil
client.templates.preview(yourtemplateid, properties, draft)
```

<a href="https://developers.sparkpost.com/api/#/reference/templates/preview" target="_blank">see SparkPost API Documentation</a>

#### Delete

Deletes a template permanently

```ruby
client.templates.delete(yourtemplateid)
```

<a href="https://developers.sparkpost.com/api/#/reference/templates/delete" target="_blank">see SparkPost API Documentation</a>

## Contributing

Not right now, but in time ...

1. Fork it ( https://github.com/leadmachineapp/simple_spark/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
