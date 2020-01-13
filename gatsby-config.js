module.exports = {
  pathPrefix: "/gatsby-orga",
  siteMetadata: {
    title: "Valley of Thiefuniverse",
    bio: "Do what you want to do, love what you love."
  },
  plugins: [
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `pages`,
        path: `${__dirname}/src/pages`
      }
    },
    {
      resolve: `gatsby-transformer-orga`,
      options: {
        // if you don't want to have server side prism code highlight
        // noHighlight: true,
      }
    }
  ]
};
