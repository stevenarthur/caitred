module IncomingMailContent
  SUPPLIER_EMAIL = <<-EVENTS
    [{
      "event":"inbound",
      "ts":1417845782,
      "msg": {
        "raw_msg":"",
        "headers": {
          "Received":[],
          "X-Google-Dkim-Signature":"",
          "X-Gm-Message-State":"",
          "Mime-Version":"1.0",
          "X-Received":"",
          "In-Reply-To":"",
          "References":"",
          "Date":"Sat, 6 Dec 2014 17:03:00 +1100",
          "Message-Id":"",
          "Subject":"Re: Job for unknown date (Enquiry ID 57)",
          "From":"Jo Cranford <jo@youchews.com>",
          "To":"Phil Doran <philtest@cake.youchews.com>",
          "Content-Type":"multipart\\/alternative; boundary=001a11c125921a16d0050985f285"
        },
        "text":"yes ok",
        "text_flowed":false,
        "html": "",
        "from_email":"jo@youchews.com",
        "from_name":"Jo Cranford",
        "to":[["philtest@cake.youchews.com","Phil Doran"]],
        "subject":"Re: Job for unknown date (Enquiry ID 57)",
        "spf": {
          "result":"none",
          "detail":""
        },
        "spam_report":
          {
            "score":1.3,
            "matched_rules":[
              {
                "name":"URIBL_BLOCKED",
                "score":0,
                "description":"ADMINISTRATOR NOTICE: The query to URIBL was blocked."
              },
              {
                "name":null,
                "score":0,
                "description":null
              },
              {
                "name":"more",
                "score":0,
                "description":"information."
              },
              {
                "name":"mandrillapp.com]",
                "score":0,
                "description":null
              },
              {"name":"RCVD_IN_DNSWL_LOW",
                "score":-0.7,
                "description":"RBL: Sender listed at http:\\/\\/www.dnswl.org\\/, low"
              },
              {
                "name":"listed",
                "score":0,
                "description":"in list.dnswl.org]"
              },
              {
                "name":"HTML_IMAGE_ONLY_28",
                "score":0.7,
                "description":"BODY: HTML: images with 2400-2800 bytes of words"
              },
              {
                "name":"HTML_MESSAGE",
                "score":0,
                "description":"BODY: HTML included in message"
              },
              {
                "name":"RDNS_NONE",
                "score":1.3,
                "description":"Delivered to internal network by a host with no rDNS"
              },
              {
                "name":"T_REMOTE_IMAGE",
                "score":0,
                "description":"Message contains an external image"
              }
            ]
          },
        "dkim": {
          "signed":false,
          "valid":false
        },
        "email":"philtest@cake.youchews.com",
        "tags":[],
        "sender":null,
        "template":null
      }
    }]
  EVENTS
end
