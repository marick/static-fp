Files in this directory contain functions that should be private to
corresponding source modules but visible to tests.

That is, `Root.TestAccess.Mod` should be imported into `Root.Mod`,
`Root.ModTest`, and nothing else.
