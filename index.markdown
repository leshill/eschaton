---
layout: default
title: eschaton
---

{% for post in site.posts %} 
  <div class="post_list_item">
    <div class="post_tab">
      <h1 class="post_header"><a href="/eschaton{{ post.url }}" style='color: #000; text-decoration: none;'>{{ post.title }}</a></h1>      
    </div>
    <div class="post_content">
      <span>{{ post.date | date_to_string }}</span>
      {{post.content}}
    </div>
  </div>
{% endfor %}
