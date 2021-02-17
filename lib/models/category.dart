import 'package:flutter/material.dart';

class Category {
  String name;
  String image;

  Category({
   this.name,
     this.image,
  });
List<Category> getCategoryList(){
return categoryList;
}

}

List<Category> categoryList = [
  Category(
    image:"https://cdn.pixabay.com/photo/2014/09/30/22/50/sandstone-467714_1280.jpg",
    name: "Abstract",
  ),
  Category(
    image: "https://cdn.pixabay.com/photo/2016/11/22/23/44/buildings-1851246_1280.jpg",
    name: "Cars",
  ),
  Category(
    image: "https://cdn.pixabay.com/photo/2015/03/11/12/31/new-york-668616_1280.jpg",
    name: "City",
  ),
  Category(
    image: "https://cdn.pixabay.com/photo/2017/06/06/15/41/tree-2377575_1280.jpg",
    name: "Minimalist",
  ),
  Category(
    image: "https://cdn.pixabay.com/photo/2015/09/09/16/05/forest-931706_1280.jpg",
    name:"Nature"
  ),
  Category(
    image: "https://cdn.pixabay.com/photo/2011/12/14/12/21/orion-nebula-11107_1280.jpg",
    name: "Space",
  ),
  Category(
    image: "https://cdn.pixabay.com/photo/2018/06/12/20/17/football-3471402_1280.jpg",
    name: "Sport",
  ),
   Category(
    image: "https://cdn.pixabay.com/photo/2016/09/29/12/54/chess-1702761_1280.jpg",
    name: "Game",
  ),
  Category(
    image: "https://cdn.pixabay.com/photo/2016/06/02/02/33/triangles-1430105_1280.png",
    name: "Color",
  ),
  Category(
    image: "https://images.unsplash.com/photo-1523554888454-84137e72c3ce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
    name: "Art",
  ),
  Category(
    image: "https://images.unsplash.com/photo-1534073133331-c4b62a557083?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
    name: "Farm",
  ),
  Category(
    image: "https://images.pexels.com/photos/248152/pexels-photo-248152.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    name: "Science",
  ),
  Category(
    image: "https://images.pexels.com/photos/390089/film-movie-motion-picture-390089.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    name: "Movie",
  ),
  Category(
    image: "https://images.pexels.com/photos/247502/pexels-photo-247502.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    name: "Animal",
  ),
  Category(
    image: "https://images.pexels.com/photos/326279/pexels-photo-326279.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    name: "Food",
  ),
];