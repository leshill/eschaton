---
layout: default
title: eschaton
---

{% for post in site.posts %} 
  <div class="post_list_item">
    <h1 class="post_header"><a href="{{ post.url }}">{{ post.title }}</a></h1>
    <span>{{ post.date | date_to_string }}</span>
    {{post.content}}
    <br/>
    <hr/>
    <hr/>  
  </div>
{% endfor %}
