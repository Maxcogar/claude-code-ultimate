import { Hero } from '@/components/Hero'
import { Features } from '@/components/Features'
import { ClaudeIntegration } from '@/components/ClaudeIntegration'

export default function HomePage() {
  return (
    <div className="space-y-16">
      <Hero />
      <Features />
      <ClaudeIntegration />
    </div>
  )
}
