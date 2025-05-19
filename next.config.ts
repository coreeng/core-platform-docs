import nextra from "nextra";

const withNextra = nextra({
  staticImage: true,
});

export default withNextra({
  output: "standalone",
});
