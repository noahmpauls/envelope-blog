const { DateTime } = require('luxon');

module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy("assets/js");
  eleventyConfig.addPassthroughCopy("assets/css");
  eleventyConfig.addPassthroughCopy("assets/svg");
  eleventyConfig.addPassthroughCopy("assets/img");
  eleventyConfig.addPassthroughCopy("admin/config.yml");
  eleventyConfig.addPassthroughCopy("favicon.ico");

  eleventyConfig.addCollection("publishedPosts", (collection) => {
    const posts = collection.getFilteredByTag("post");
    return posts.filter(p => p.data.published);
  });

  eleventyConfig.addFilter('postDate', dateObj => {
    return DateTime.fromJSDate(dateObj).toUTC().toLocaleString(DateTime.DATE_HUGE)
  })

  eleventyConfig.addFilter('postPreviewDate', dateObj => {
    return DateTime.fromJSDate(dateObj).toUTC().toLocaleString(DateTime.DATE_FULL)
  })

  eleventyConfig.addFilter('monthDayDate', dateObj => {
    return DateTime.fromJSDate(dateObj).toUTC().toLocaleString({month: 'long', day: 'numeric'})
  })

  // https://11ty.rocks/eleventyjs/content/#excerpt-filter
  eleventyConfig.addFilter('excerpt', templateContent => {
    const content = templateContent.replace(/(<([^>]+)>)/gi, "");
    return content.substr(0, content.lastIndexOf(" ", 200)) + "...";
  })

  // https://11ty.rocks/eleventyjs/content/#addnbsp-filter
  eleventyConfig.addFilter('addNbsp', str => {
    if (!str) { return }
    let title = str.replace(/((.*)\s(.*))$/g, "$2\u00A0$3");
    title = title.replace(/"(.*)"/g, '\\"$1\\"');
    return title
  })

  return {}
}
