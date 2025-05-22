import nextra from "nextra";

const withNextra = nextra({
  staticImage: true,
  defaultShowCopyCode: true,
});

export default withNextra({
  output: "standalone",
});
