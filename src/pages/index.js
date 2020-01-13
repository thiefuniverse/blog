import React from "react";
import { Link } from "gatsby";
import { graphql } from "gatsby";
import Layout from "../components/layout";

class BlogIndex extends React.Component {
  render() {
    const posts = this.props.data.allOrgContent.edges;
    const _posts = posts.map(({ node }) => {
      const title = node.metadata.title || node.fields.slug;
      const date = node.metadata.date || "no date";
      return (
        <div>
          <h3 style={{ marginBottom: "0.2em" }}>
            <small>{date}</small> <Link to={node.fields.slug}>{title}</Link>
          </h3>
        </div>
      );
    });
    return (
      <Layout>
        {this.props.data.site.siteMetadata.bio}
        {_posts}
      </Layout>
    );
  }
}

export default BlogIndex;

export const pageQuery = graphql`
  query IndexQuery {
    site {
      siteMetadata {
        title
        bio
      }
    }
    allOrgContent(sort: { order: DESC, fields: metadata___date }) {
      edges {
        node {
          fields {
            slug
          }
          metadata {
            title
            date
          }
        }
      }
    }
  }
`;
