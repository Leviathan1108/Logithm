import Link from 'next/link'
import { ArrowRight, Play, BookOpen, Trophy, Users, Zap, Brain, Code } from 'lucide-react'
import { Button } from '@/components/ui/Button'

export default function Home() {
  return (
    <div className="bg-white">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-to-br from-blue-50 to-indigo-100 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-900 mb-6">
                Learn Algorithms the
                <span className="text-blue-600"> Fun Way</span>
              </h1>
              <p className="text-xl text-gray-600 mb-8 leading-relaxed">
                Master branching and repetition algorithms through interactive videos,
                hands-on exercises, and gamified learning. Perfect for beginners who
                want to understand coding concepts without the complexity.
              </p>
              <div className="flex flex-col sm:flex-row gap-4">
                <Link href="/signup">
                  <Button size="lg" className="w-full sm:w-auto">
                    Start Learning Free
                    <ArrowRight className="ml-2 h-5 w-5" />
                  </Button>
                </Link>
                <Link href="/lessons">
                  <Button variant="outline" size="lg" className="w-full sm:w-auto">
                    <Play className="mr-2 h-5 w-5" />
                    Preview Lessons
                  </Button>
                </Link>
              </div>
            </div>
            <div className="relative">
              <div className="bg-white rounded-2xl shadow-2xl p-8 border border-gray-200">
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-blue-50 rounded-lg p-4 text-center">
                    <Brain className="h-8 w-8 text-blue-600 mx-auto mb-2" />
                    <div className="text-2xl font-bold text-gray-900">Visual</div>
                    <div className="text-sm text-gray-600">Learning</div>
                  </div>
                  <div className="bg-green-50 rounded-lg p-4 text-center">
                    <Zap className="h-8 w-8 text-green-600 mx-auto mb-2" />
                    <div className="text-2xl font-bold text-gray-900">Interactive</div>
                    <div className="text-sm text-gray-600">Exercises</div>
                  </div>
                  <div className="bg-purple-50 rounded-lg p-4 text-center">
                    <Trophy className="h-8 w-8 text-purple-600 mx-auto mb-2" />
                    <div className="text-2xl font-bold text-gray-900">Points</div>
                    <div className="text-sm text-gray-600">Rewards</div>
                  </div>
                  <div className="bg-orange-50 rounded-lg p-4 text-center">
                    <Users className="h-8 w-8 text-orange-600 mx-auto mb-2" />
                    <div className="text-2xl font-bold text-gray-900">Social</div>
                    <div className="text-sm text-gray-600">Learning</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl sm:text-4xl font-bold text-gray-900 mb-4">
              Why Learn Algorithms with Logithm?
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              We've designed the perfect learning experience for complete beginners
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <div className="bg-white p-8 rounded-xl shadow-md border border-gray-100">
              <div className="bg-blue-100 rounded-lg p-3 inline-flex mb-4">
                <Play className="h-6 w-6 text-blue-600" />
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">Video & Audio Lessons</h3>
              <p className="text-gray-600">
                Learn through engaging animated videos and audio explanations that make complex concepts simple and memorable.
              </p>
            </div>

            <div className="bg-white p-8 rounded-xl shadow-md border border-gray-100">
              <div className="bg-green-100 rounded-lg p-3 inline-flex mb-4">
                <Code className="h-6 w-6 text-green-600" />
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">Interactive Exercises</h3>
              <p className="text-gray-600">
                Practice with drag-and-drop coding blocks and visual flowcharts that build your understanding step by step.
              </p>
            </div>

            <div className="bg-white p-8 rounded-xl shadow-md border border-gray-100">
              <div className="bg-purple-100 rounded-lg p-3 inline-flex mb-4">
                <Trophy className="h-6 w-6 text-purple-600" />
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">Earn Points & Climb Ranks</h3>
              <p className="text-gray-600">
                Stay motivated with our gamified system that rewards your progress and lets you compete on leaderboards.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Learning Path Section */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl sm:text-4xl font-bold text-gray-900 mb-4">
              Your Learning Journey
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Start with the basics and progress to advanced concepts at your own pace
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="bg-white p-6 rounded-lg border-2 border-transparent hover:border-blue-500 transition-colors">
              <div className="text-blue-600 font-semibold mb-2">Level 1</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-3">Sequential Thinking</h3>
              <p className="text-gray-600 text-sm">
                Learn step-by-step processes through recipes, routines, and directions.
              </p>
            </div>

            <div className="bg-white p-6 rounded-lg border-2 border-transparent hover:border-blue-500 transition-colors">
              <div className="text-green-600 font-semibold mb-2">Level 2</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-3">Branching Logic</h3>
              <p className="text-gray-600 text-sm">
                Master if/else decisions through real-world scenarios and examples.
              </p>
            </div>

            <div className="bg-white p-6 rounded-lg border-2 border-transparent hover:border-blue-500 transition-colors">
              <div className="text-purple-600 font-semibold mb-2">Level 3</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-3">Repetition Patterns</h3>
              <p className="text-gray-600 text-sm">
                Understand loops and iteration through everyday repetitive tasks.
              </p>
            </div>

            <div className="bg-white p-6 rounded-lg border-2 border-transparent hover:border-blue-500 transition-colors">
              <div className="text-orange-600 font-semibold mb-2">Level 4</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-3">Combined Concepts</h3>
              <p className="text-gray-600 text-sm">
                Apply all three concepts together to solve complex problems.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-to-r from-blue-600 to-indigo-600">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl sm:text-4xl font-bold text-white mb-6">
            Ready to Start Your Algorithm Journey?
          </h2>
          <p className="text-xl text-blue-100 mb-8">
            Join thousands of learners who are mastering algorithms the fun way.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link href="/signup">
              <Button size="lg" className="bg-white text-blue-600 hover:bg-gray-100">
                Get Started Free
                <ArrowRight className="ml-2 h-5 w-5" />
              </Button>
            </Link>
            <Link href="/lessons">
              <Button
                variant="outline"
                size="lg"
                className="border-white text-white hover:bg-white hover:text-blue-600"
              >
                <BookOpen className="mr-2 h-5 w-5" />
                Browse Lessons
              </Button>
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}
