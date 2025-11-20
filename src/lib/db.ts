// Temporary mock database for development
// TODO: Replace with actual Prisma client when adapter issues are resolved

interface MockDB {
  user: any
  lesson: any
  userProgress: any
  quizQuestion: any
  quizResult: any
  point: any
  exercise: any
  exerciseAttempt: any
}

export const db: MockDB = {
  user: {
    findUnique: () => null,
    findFirst: () => null,
    create: () => null,
    update: () => null,
    delete: () => null,
    findMany: () => [],
  },
  lesson: {
    findUnique: () => null,
    findFirst: () => null,
    create: () => null,
    update: () => null,
    delete: () => null,
    findMany: () => [],
  },
  userProgress: {
    findUnique: () => null,
    findFirst: () => null,
    create: () => null,
    update: () => null,
    delete: () => null,
    findMany: () => [],
  },
  quizQuestion: {
    findUnique: () => null,
    findFirst: () => null,
    create: () => null,
    update: () => null,
    delete: () => null,
    findMany: () => [],
  },
  quizResult: {
    findUnique: () => null,
    findFirst: () => null,
    create: () => null,
    update: () => null,
    delete: () => null,
    findMany: () => [],
  },
  point: {
    findUnique: () => null,
    findFirst: () => null,
    create: () => null,
    update: () => null,
    delete: () => null,
    findMany: () => [],
  },
  exercise: {
    findUnique: () => null,
    findFirst: () => null,
    create: () => null,
    update: () => null,
    delete: () => null,
    findMany: () => [],
  },
  exerciseAttempt: {
    findUnique: () => null,
    findFirst: () => null,
    create: () => null,
    update: () => null,
    delete: () => null,
    findMany: () => [],
  },
}