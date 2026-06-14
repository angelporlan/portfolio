import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
  type: 'content',
  schema: ({ image }) => z.object({
    title: z.string(),
    subtitle: z.string(),
    date: z.date(),
    tags: z.array(z.string()),   // e.g. ['SaaS', 'Docker', 'AI & LLMs']
    lang: z.enum(['en', 'es']).default('es'),
    draft: z.boolean().default(false),
    translation: z.string().optional(),
    cover: image().optional(),
  }),
});

export const collections = { blog };
